import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public final class ManageModelItemsViewController: UIViewController {
    private let tableView: ManageModelItemsTableView
    private let dataSource: ManageModelItemsDataSource

    private lazy var searchItemTextField: TextFieldWithCancel =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.placeholder = "Search item..."
            $0.layer.zPosition = 1
        }

    private let viewModel: ManageModelItemsViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: ManageModelItemsViewModel) {
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
        self.viewModel.fetchModelItems()
    }

    private func setupView() {
        title = "Manage Items"
        view.backgroundColor = .background

        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(searchItemTextField)
        NSLayoutConstraint.activate([
            searchItemTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchItemTextField.topAnchor.constraint(equalTo: view.topAnchor),
            searchItemTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchItemTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: searchItemTextField.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bind() {
        searchItemTextField.onAction
            .sink { [weak self] in self?.hansleSearchItemTextField($0) }
            .store(in: &cancellables)

        tableView.onAction
            .sink { [weak self] in self?.handleTableViewAction($0) }
            .store(in: &cancellables)

        viewModel.modelItemsPublisher
            .sink { [weak self] in
                self?.dataSource.apply($0)
                self?.refreshUserInterface()
            }
            .store(in: &cancellables)

        viewModel.onAction
            .sink { [weak self] in self?.handleViewModelAction($0) }
            .store(in: &cancellables)
    }

    private func handleTableViewAction(_ action: ManageModelItemsTableView.Action) {
        switch action {
        case .doNothing:
            break
        }
    }

    private func hansleSearchItemTextField(_ action: TextFieldWithCancel.Action) {
        switch action {
        case .change, .confirm:
            return
        case let .validationError(text):
            showInfoPopup(with: text)
        }
    }

    private func handleViewModelAction(_ action: ManageModelItemsViewModel.Action) {
        switch action {
        case .doNothing:
            break
        }
    }

    private func showInfoPopup(with text: String) {
        let controller = UIAlertController(title: "", message: text, preferredStyle: .alert)
        controller.addAction(.init(title: "OK", style: .default))
        present(controller, animated: true)
    }

    private func refreshUserInterface() {
        // Not implemented
    }
}
