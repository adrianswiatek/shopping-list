import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public protocol ListsViewControllerDelegate: AnyObject {
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
        configure(.init(
            image: #imageLiteral(resourceName: "Restore"),
            primaryAction: .init { [weak self] _ in self?.viewModel.restoreList() })) {
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

        viewModel.messagePublisher
            .sink { [weak self] in self?.showMessagePopup(with: $0) }
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
        case .clearBasket(let uuid):
            viewModel.clearBasketOfList(with: uuid)
        case .clearItemsToBuy(let uuid):
            viewModel.clearList(with: uuid)
        case .editList(let list):
            showEditPopupForList(list)
        case .removeList(let uuid):
            viewModel.removeList(with: uuid)
        case .selectList(let list):
            delegate?.goToItems(from: list)
        case .sendListToWatch(let uuid):
            viewModel.sendToWatchList(with: uuid)
        }
    }

    private func handleAddListTextFieldAction(_ action: TextFieldWithCancel.Action) {
        switch action {
        case .change:
            return // Do nothing
        case let .confirm(text):
            viewModel.addList(with: text)
        case let .validationError(text):
            showMessagePopup(with: text)
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
        controller.set(ValidationButtonRuleLeaf(
            message: "List with given name already exists.",
            predicate: { [weak self] in self?.viewModel.hasList(with: $0) == false }
        ))
        present(controller, animated: true)
    }

    private func showMessagePopup(with text: String) {
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
