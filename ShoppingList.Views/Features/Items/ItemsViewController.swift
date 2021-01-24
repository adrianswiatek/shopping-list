import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public protocol ItemsViewControllerDelegate: class {
    func goToBasket()
    func goToEditItem(_ item: ItemToBuyViewModel)
    func goToCreateItem()
    func didDismiss()
}

public final class ItemsViewController: UIViewController {
    public weak var delegate: ItemsViewControllerDelegate?

    private var items = [[Item]]()
    private var categories = [ItemsCategory]()

    private let tableView: ItemsTableView
    private let dataSource: ItemsDataSource
    private let toolbar: ItemsToolbar
    
    private let addItemTextField: TextFieldWithCancel =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.set(ValidationButtonRuleLeaf.notEmptyItemRule)
            $0.layer.zPosition = 1
            $0.placeholder = "Add new item..."
        }

    private let bottomView: UIView =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .background
        }
    
    private lazy var filledBasketBarButtonItem: UIBarButtonItem =
        .init(image: #imageLiteral(resourceName: "Basket"), primaryAction: .init { [weak self] _ in self?.goToBasket() })
    
    private lazy var emptyBasketBarButtonItem: UIBarButtonItem =
        .init(image: #imageLiteral(resourceName: "EmptyBasket"), primaryAction: .init { [weak self] _ in self?.goToBasket() })
    
    private lazy var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in
            self?.viewModel.restoreItem()
        })
        barButtonItem.isEnabled = false
        return barButtonItem
    }()

    private var cancellables: Set<AnyCancellable>

    private let itemsFormatter: SharedItemsFormatter
    private let viewModel: ItemsViewModel

    public init(viewModel: ItemsViewModel) {
        self.viewModel = viewModel
        self.itemsFormatter = .init()

        self.tableView = .init()
        self.dataSource = .init(tableView)
        self.toolbar = .init()

        self.cancellables = []

        super.init(nibName: nil, bundle: nil)

        self.bind()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.viewModel.fetchItems()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshUserInterface()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            self.delegate?.didDismiss()
        }

        self.viewModel.cleanUp()
    }
    
    private func setupView() {
        navigationItem.title = viewModel.list.name

        view.addSubview(addItemTextField)
        NSLayoutConstraint.activate([
            addItemTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addItemTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addItemTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addItemTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addItemTextField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func bind() {
        viewModel.itemsPublisher
            .sink { [weak self] in
                self?.dataSource.apply($0)
                self?.tableView.refreshBackground()
                self?.toolbar.setButtonsAs(enabled: !$0.isEmpty)
            }
            .store(in: &cancellables)

        viewModel.statePublisher
            .sink { [weak self] in self?.handleStateChange($0) }
            .store(in: &cancellables)

        addItemTextField.onAction
            .sink { [weak self] in self?.handleAddListTextFieldAction($0) }
            .store(in: &cancellables)

        tableView.onAction
            .sink { [weak self] in self?.handleTableViewAction($0) }
            .store(in: &cancellables)

        toolbar.onAction
            .sink { [weak self] in self?.handleToolbarAction($0) }
            .store(in: &cancellables)
    }

    private func handleStateChange(_ state: ItemsViewModel.State) {
        switch state {
        case .editing:
            tableView.setEditing(true, animated: true)
            toolbar.setEditMode()
        case .regular:
            tableView.setEditing(false, animated: true)
            toolbar.setRegularMode()
        }
    }

    private func handleAddListTextFieldAction(_ action: TextFieldWithCancel.Action) {
        switch action {
        case let .confirm(text):
            viewModel.addItem(with: text)
        case let .validationError(text):
            showValidationError(with: text)
        }
    }

    private func handleTableViewAction(_ action: ItemsTableView.Action) {
        switch action {
        case .rowTapped:
            toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
        }
    }

    private func handleToolbarAction(_ action: ItemsToolbar.Action) {
        switch action {
        case .action:
            break
        case .add:
            delegate?.goToCreateItem()
        case .cancel:
            viewModel.setState(.regular)
        case .edit:
            viewModel.setState(.editing)
        case .moveToList:
            break
        case .remove:
            break
        }
    }

    private func showValidationError(with text: String) {
        let controller = UIAlertController(title: "", message: text, preferredStyle: .alert)
        controller.addAction(.init(title: "OK", style: .default))
        present(controller, animated: true)
    }
    
    private func refreshUserInterface(after: Double = 0) {
        setTopBarButtons()
    }
    
    private func setTopBarButtons() {
        restoreBarButtonItem.isEnabled = viewModel.isRestoreButtonEnabled
        navigationItem.rightBarButtonItems = [
            viewModel.hasItemsInBasket() ? filledBasketBarButtonItem : emptyBasketBarButtonItem,
            restoreBarButtonItem
        ]
    }

    private func goToBasket() {
        delegate?.goToBasket()
    }
}

extension ItemsViewController: AddToBasketDelegate {
    public func addItemToBasket(_ item: ItemToBuyViewModel) {
        viewModel.moveToBasketItem(with: item.uuid)
    }
}

extension ItemsViewController: TextFieldWithCancelDelegate {
    public func textFieldWithCancel(
        _ textFieldWithCancel: TextFieldWithCancel,
        didReturnWith text: String
    ) {
        viewModel.addItem(with: text)
    }
}

extension ItemsViewController { //}: ItemsToolbarDelegate {
    public func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }

    public func actionButtonDidTap() {
        let shareAction = UIAlertAction(title: "Share", style: .default) { [weak self] _ in
            self?.openShareItemsAlert()
        }

        let moveAllToBasketAction = UIAlertAction(title: "Move all to basket", style: .default) { _ in
            // TODO: command
            // let command = AddItemsToBasketCommand(self.items.flatMap { $0 }, self)
            // CommandInvoker.shared.execute(command)
        }

        let deleteAllAction = UIAlertAction(title: "Remove all", style: .destructive) { _ in
            // TODO: command
            // let command = RemoveItemsFromListCommand(self.items.flatMap { $0 }, self)
            // CommandInvoker.shared.execute(command)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if self.items.count > 0 {
            alertController.addAction(shareAction)
        }

        alertController.addAction(moveAllToBasketAction)
        alertController.addAction(deleteAllAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    public func deleteAllButtonDidTap() {
        guard getSelectedItems() != nil else { return }
        // TODO: command
        // let command = RemoveItemsFromListCommand(selectedItems, self)
        // CommandInvoker.shared.execute(command)
    }

    public func moveAllToBasketButtonDidTap() {
        guard getSelectedItems() != nil else { return }
        // TODO: command
        // let command = AddItemsToBasketCommand(selectedItems, self)
        // CommandInvoker.shared.execute(command)
    }

    private func getSelectedItems() -> [Item]? {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return nil }
        return selectedIndexPaths.sorted { $0 > $1 }.map { self.items[$0.section][$0.row] }
    }

    private func openShareItemsAlert() {
        let shareWithCategories = UIAlertAction(title: "... with categories", style: .default) { [unowned self] _ in
            let formattedItems = self.itemsFormatter.format(self.items, withCategories: self.categories)
            self.showActivityController(formattedItems)
        }

        let shareWithoutCategories = UIAlertAction(title: "... without categories", style: .default) { [unowned self] _ in
            let formattedItems = self.itemsFormatter.format(self.items)
            self.showActivityController(formattedItems)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(title: "Share ...", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(shareWithCategories)
        alertController.addAction(shareWithoutCategories)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    private func showActivityController(_ formattedItems: String) {
        assert(!formattedItems.isEmpty, "Formatted items must have items.")
        present(UIActivityViewController(activityItems: [formattedItems], applicationActivities: nil), animated: true)
    }

    public func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshUserInterface()
    }
}
