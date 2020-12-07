import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public protocol ListsViewControllerDelegate: class {
    func goToSettings()
    func showEditPopupForList(with name: String, completion: @escaping (String) -> Void)
    func showRemoveListWarning(onAccepted: @escaping () -> Void)
    func showValidationError(with text: String)
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
        configure(.init(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in self?.viewModel.restore() })) {
            $0.isEnabled = false
        }

    private let viewModel: ListsViewModel
    private var cancellables: [AnyCancellable]

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

    public func refreshUserInterface() {
        if viewModel.hasLists {
            tableView.backgroundView = nil
        } else {
            tableView.setTextIfEmpty("You have not added any lists yet")
        }

        restoreBarButtonItem.isEnabled = viewModel.isRestoreButtonEnabled
        navigationItem.rightBarButtonItems = [goToSettingsBarButtonItem, restoreBarButtonItem]
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
        case let .editList(id, name):
            delegate?.showEditPopupForList(with: name) { [weak self] in
                guard !$0.isEmpty else { return }
                self?.viewModel.updateList(with: id, name: $0)
            }
        case let .removeList(id):
            if viewModel.isListEmpty(with: id) {
                viewModel.removeEmptyList(with: id)
            } else {
                delegate?.showRemoveListWarning(onAccepted: { [weak self] in
                    self?.viewModel.removeList(with: id)
                })
            }
        case let .clearItemsToBuy(id):
            viewModel.clearList(with: id)
        case let .clearBasket(id):
            viewModel.clearBasketOfList(with: id)
        }
    }

    private func handleAddListTextFieldAction(_ action: TextFieldWithCancel.Action) {
        switch action {
        case let .confirm(text):
            viewModel.addList(with: text)
        case let .validationError(text):
            delegate?.showValidationError(with: text)
        }
    }
}

extension ListsViewController: ItemsViewControllerDelegate {
    public func itemsViewControllerDidDismiss(_ itemsViewController: ItemsViewController) {
        viewModel.fetchLists()
    }
}
