import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public protocol ListsViewControllerDelegate: class {
    func goToSettings()
    func goToItems(from list: ListViewModel)
}

public final class ListsViewController: UIViewController {
    public weak var delegate: ListsViewControllerDelegate?

    private let tableView: ListsTableView
    private let dataSource: ListsDataSource

    private lazy var addListTextField: TextFieldWithCancel =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.placeholder = "Add new list..."
            $0.layer.zPosition = 1
        }
    
    private lazy var goToSettingsBarButtonItem: UIBarButtonItem =
        .init(image: #imageLiteral(resourceName: "Settings"), primaryAction: .init { [weak self] _ in
            self?.delegate?.goToSettings()
        })

    private lazy var restoreBarButtonItem: UIBarButtonItem =
        configure(.init(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in self?.viewModel.restoreList() })) {
            $0.isEnabled = false
        }

    private let viewModel: ListsViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: ListsViewModel) {
        self.viewModel = viewModel
        self.cancellables = []

        self.tableView = .init()
        self.dataSource = .init(tableView)

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
        self.viewModel.fetchLists()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.cleanUp()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshUserInterface()
    }

    private func setupView() {
        navigationItem.title = "My lists"

        view.addSubview(addListTextField)
        NSLayoutConstraint.activate([
            addListTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addListTextField.topAnchor.constraint(equalTo: view.topAnchor),
            addListTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addListTextField.heightAnchor.constraint(equalToConstant: 50),
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: addListTextField.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bind() {
        viewModel.listsPublisher
            .sink { [weak self] in
                self?.dataSource.apply($0)
                self?.refreshUserInterface()
            }
            .store(in: &cancellables)

        tableView.onAction
            .sink { [weak self] in self?.handleTableViewAction($0) }
            .store(in: &cancellables)

        addListTextField.onAction
            .sink { [weak self] in self?.handleAddListTextFieldAction($0) }
            .store(in: &cancellables)
    }

    private func handleTableViewAction(_ action: ListsTableView.Action) {
        switch action {
        case .clearBasket(let uuid) where viewModel.isBasketEmptyInList(with: uuid):
            viewModel.clearBasketOfList(with: uuid)
        case .clearBasket(let uuid):
            showClearBasketWarningForList(with: uuid)
        case .clearItemsToBuy(let uuid) where viewModel.isEmptyList(with: uuid):
            viewModel.clearList(with: uuid)
        case .clearItemsToBuy(let uuid):
            showClearItemsWarningForList(with: uuid)
        case .editList(let list):
            showEditPopupForList(list)
        case .removeList(let uuid) where viewModel.isEmptyList(with: uuid):
            viewModel.removeList(with: uuid)
        case .removeList(let uuid):
            showRemoveListWarningForList(with: uuid)
        case .selectList(let list):
            delegate?.goToItems(from: list)
        }
    }

    private func handleAddListTextFieldAction(_ action: TextFieldWithCancel.Action) {
        switch action {
        case let .confirm(text):
            viewModel.addList(with: text)
        case let .validationError(text):
            showValidationError(with: text)
        }
    }

    private func showEditPopupForList(_ list: ListViewModel) {
        let controller = PopupWithTextFieldController()
        controller.modalPresentationStyle = .overFullScreen
        controller.popupTitle = "Edit list name"
        controller.placeholder = "Enter list name..."
        controller.text = list.name
        controller.saved = { [weak self] in
            guard !$0.isEmpty else { return }
            self?.viewModel.updateList(with: list.uuid, name: $0)
        }
        present(controller, animated: true)
    }

    private func showRemoveListWarningForList(with id: UUID) {
        let controller = UIAlertController(
            title: "Remove list",
            message: "There are items in the list, that have not been bought yet. If continue, all list items will be removed.",
            preferredStyle: .actionSheet
        )

        controller.addAction(.init(title: "Cancel", style: .cancel))
        controller.addAction(.init(title: "Remove permanently", style: .destructive) { [weak self] _ in
            self?.viewModel.removeList(with: id)
        })

        present(controller, animated: true)
    }

    private func showClearItemsWarningForList(with id: UUID) {
        let controller = UIAlertController(
            title: "Clear items to buy",
            message: "If continue, all list items will be permanently removed.",
            preferredStyle: .actionSheet
        )

        controller.addAction(.init(title: "Cancel", style: .cancel))
        controller.addAction(.init(title: "Clear items", style: .destructive) { [weak self] _ in
            self?.viewModel.clearList(with: id)
        })

        present(controller, animated: true)
    }

    private func showClearBasketWarningForList(with id: UUID) {
        let controller = UIAlertController(
            title: "Clear basket",
            message: "If continue, all list items in the basket will be permanently removed.",
            preferredStyle: .actionSheet
        )

        controller.addAction(.init(title: "Cancel", style: .cancel))
        controller.addAction(.init(title: "Clear basket", style: .destructive) { [weak self] _ in
            self?.viewModel.clearBasketOfList(with: id)
        })

        present(controller, animated: true)
    }

    private func showValidationError(with text: String) {
        let controller = UIAlertController(title: "", message: text, preferredStyle: .alert)
        controller.addAction(.init(title: "OK", style: .default))
        present(controller, animated: true)
    }

    private func refreshUserInterface() {
        if viewModel.hasLists {
            tableView.backgroundView = nil
        } else {
            tableView.setBackgroundLabel("You have not added any lists yet")
        }

        restoreBarButtonItem.isEnabled = viewModel.isRestoreButtonEnabled
        navigationItem.rightBarButtonItems = [goToSettingsBarButtonItem, restoreBarButtonItem]
    }
}
