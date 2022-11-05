import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public final class ManageModelItemsViewController: UIViewController {
    private let tableView: ManageModelItemsTableView
    private let dataSource: ManageModelItemsDataSource

    private lazy var addCategoryTextField: TextFieldWithCancel =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.placeholder = "Add new item..."
            $0.set(validationButtonRule())
            $0.layer.zPosition = 1
        }

    private lazy var restoreBarButtonItem: UIBarButtonItem =
        configure(.init(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in
            self?.viewModel.restoreCategory()
        })) {
            $0.isEnabled = false
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
        self.viewModel.fetchCategories()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.cleanUp()
    }

    private func setupView() {
        title = "Manage Items"
        view.backgroundColor = .background

        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(addCategoryTextField)
        NSLayoutConstraint.activate([
            addCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addCategoryTextField.topAnchor.constraint(equalTo: view.topAnchor),
            addCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addCategoryTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: addCategoryTextField.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bind() {
        addCategoryTextField.onAction
            .sink { [weak self] in self?.handleAddListTextFieldAction($0) }
            .store(in: &cancellables)

//        tableView.onAction
//            .sink { [weak self] in self?.handleTableViewAction($0) }
//            .store(in: &cancellables)

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

    private func validationButtonRule() -> ValidationButtonRule {
        let notEmptyRule = ValidationButtonRuleLeaf.notEmptyItemRule
        let uniqueRule = ValidationButtonRuleLeaf(
            message: "Given item alread exists.",
            predicate: { [weak self] in self?.viewModel.hasModelItem(withName: $0) == true }
        )
        return ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule)
    }

    private func handleTableViewAction(_ action: ManageModelItemsTableView.Action) {
        switch action {
        case .doNothing:
            break
        }
    }

    private func handleAddListTextFieldAction(_ action: TextFieldWithCancel.Action) {
        switch action {
        case let .confirm(text):
            viewModel.addModelItem(withName: text)
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
        restoreBarButtonItem.isEnabled = viewModel.isRestoreButtonEnabled
        navigationItem.rightBarButtonItem = restoreBarButtonItem
    }
}
