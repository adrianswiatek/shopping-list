import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public final class ManageCategoriesViewController: UIViewController {
    private var items = [Item]()

    private let tableView: ManageCategoriesTableView
    private let dataSource: ManageCategoriesDataSource

    private lazy var addCategoryTextField: TextFieldWithCancel =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.placeholder = "Add new category..."
            $0.set(validationButtonRule())
            $0.layer.zPosition = 1
        }
    
    private lazy var restoreBarButtonItem: UIBarButtonItem =
        configure(.init(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in self?.viewModel.restoreCategory() })) {
            $0.isEnabled = false
        }

    private let viewModel: ManageCategoriesViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: ManageCategoriesViewModel) {
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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchItems()
        self.tableView.reloadData()
        self.refreshUserInterface()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.cleanUp()
    }
    
    public func refreshUserInterface() {
        restoreBarButtonItem.isEnabled = viewModel.isRestoreButtonEnabled
        navigationItem.rightBarButtonItem = restoreBarButtonItem
    }
    
    public func fetchItems() {
        // Todo: repository
        // items = Repository.shared.getItems()
    }

    private func setupView() {
        title = "Manage Categories"
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

        viewModel.categoriesPublisher
            .sink { [weak self] in self?.dataSource.apply($0) }
            .store(in: &cancellables)
    }

    private func validationButtonRule() -> ValidationButtonRule {
        let notEmptyRule = ValidationButtonRuleLeaf.notEmptyCategoryRule
        let uniqueRule = ValidationButtonRuleLeaf(
            message: "Category with given name already exists.",
            predicate: { [weak self] in self?.viewModel.hasCategory(with: $0) == true }
        )
        return ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule)
    }

    private func handleAddListTextFieldAction(_ action: TextFieldWithCancel.Action) {
        switch action {
        case let .confirm(text):
            viewModel.addCategory(with: text)
        case let .validationError(text):
            showValidationError(with: text)
        }
    }

    private func showValidationError(with text: String) {
        let controller = UIAlertController(title: "", message: text, preferredStyle: .alert)
        controller.addAction(.init(title: "OK", style: .default))
        present(controller, animated: true)
    }
}
