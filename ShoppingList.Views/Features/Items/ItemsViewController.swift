import _Concurrency
import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public protocol ItemsViewControllerDelegate: AnyObject {
    func goToBasket()
    func goToCreateItem()
    func goToEditItem(_ item: ItemToBuyViewModel)
    func goToSearchItemForList(_ list: ListViewModel)
    func didDismiss()
}

public final class ItemsViewController: UIViewController {
    public weak var delegate: ItemsViewControllerDelegate?

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

    private lazy var basketBarButtonItem: UIBarButtonItem =
        UIBarButtonItem(
            image: #imageLiteral(resourceName: "EmptyBasket"),
            primaryAction: .init { [weak self] _ in self?.delegate?.goToBasket() }
        )
    
    private lazy var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in
            self?.viewModel.restoreItem()
        })
        barButtonItem.isEnabled = false
        return barButtonItem
    }()

    private let viewModel: ItemsViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: ItemsViewModel) {
        self.viewModel = viewModel

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

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.cleanUp()

        if isMovingFromParent {
            self.delegate?.didDismiss()
        }
    }

    private func setupView() {
        navigationItem.title = viewModel.list.name
        navigationItem.rightBarButtonItems = [basketBarButtonItem, restoreBarButtonItem]
        view.backgroundColor = .background

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
        viewModel.sectionsPublisher
            .sink { [weak self] in
                guard let self = self else { return }

                self.dataSource.apply($0)
                self.toolbar.setButtonsAs(enabled: !$0.isEmpty)

                DispatchQueue.main.async {
                    self.tableView.refreshBackground()
                }
            }
            .store(in: &cancellables)

        viewModel.itemsMovedPublisher
            .sink { [weak self] in
                guard $0.fromSection == $0.toSection else { return }
                self?.dataSource.disableAnimationOnce()
            }
            .store(in: &cancellables)

        viewModel.isRestoreButtonEnabledPublisher
            .assign(to: \.isEnabled, on: restoreBarButtonItem)
            .store(in: &cancellables)

        viewModel.hasItemsInTheBasketPublisher
            .map { $0 ? #imageLiteral(resourceName: "Basket") : #imageLiteral(resourceName: "EmptyBasket") }
            .assign(to: \.image, on: basketBarButtonItem)
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

        dataSource.onAction
            .sink { [weak self] in self?.handleDataSourceAction($0) }
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
        case .change:
            return // Do nothing
        case let .confirm(text):
            viewModel.addItem(with: text)
        case let .validationError(text):
            showValidationError(with: text)
        }
    }

    private func handleTableViewAction(_ action: ItemsTableView.Action) {
        switch action {
        case .addItemToBasket(let uuid):
            viewModel.addToBasketItems(with: [uuid])
        case .editItem(let item):
            delegate?.goToEditItem(item)
        case .moveItem(let fromIndexPath, let toIndexPath):
            viewModel.moveItem(
                fromPosition: (fromIndexPath.section, fromIndexPath.row),
                toPosition: (toIndexPath.section, toIndexPath.row)
            )
        case .removeItem(let uuid):
            viewModel.removeItems(with: [uuid])
        case .rowTapped:
            toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
        }
    }

    private func handleDataSourceAction(_ action: ItemsDataSource.Action) {
        switch action {
        case .addItemToBasket(let uuid):
            viewModel.addToBasketItems(with: [uuid])
        }
    }

    private func handleToolbarAction(_ action: ItemsToolbar.Action) {
        switch action {
        case .action:
            showActionSheet()
        case .add:
            delegate?.goToCreateItem()
        case .cancel:
            viewModel.setState(.regular)
        case .edit:
            viewModel.setState(.editing)
        case .moveToList:
            let selectedItems = tableView.selectedItems()
            viewModel.addToBasketItems(with: selectedItems.map { $0.uuid })
        case .remove:
            let selectedItems = tableView.selectedItems()
            viewModel.removeItems(with: selectedItems.map { $0.uuid })
        case .search:
            delegate?.goToSearchItemForList(viewModel.list)
        }
    }

    private func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if viewModel.canShareItems {
            alertController.addAction(.init(title: "Share", style: .default) { [weak self] _ in
                self?.openShareItemsAlert()
            })
        }

        alertController.addAction(.init(title: "Add all to basket", style: .default) { [weak self] _ in
            self?.viewModel.addToBasketAllItems()
        })
        alertController.addAction(.init(title: "Remove all", style: .destructive) { [weak self] _ in
            self?.viewModel.removeAllItems()
        })
        alertController.addAction(.init(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    private func openShareItemsAlert() {
        let alertController = UIAlertController(title: "Share ...", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "... with Apple Watch", style: .default) { [weak self] _ in
            self?.viewModel.sendListToWatch()
        })
        alertController.addAction(.init(title: "... with categories", style: .default) { [weak self] _ in
            guard let formattedItems = self?.viewModel.formattedItemsWithCategories() else { return }
            self?.showActivityController(formattedItems)
        })
        alertController.addAction(.init(title: "... without categories", style: .default) { [weak self] _ in
            guard let formattedItems = self?.viewModel.formattedItemsWithoutCategories() else { return }
            self?.showActivityController(formattedItems)
        })
        alertController.addAction(.init(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    private func showActivityController(_ formattedItems: String) {
        assert(!formattedItems.isEmpty, "Formatted items must have items.")

        present(UIActivityViewController(
            activityItems: [formattedItems],
            applicationActivities: nil
        ), animated: true)
    }

    private func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
    }

    private func showValidationError(with text: String) {
        let controller = UIAlertController(title: "", message: text, preferredStyle: .alert)
        controller.addAction(.init(title: "OK", style: .default))
        present(controller, animated: true)
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
