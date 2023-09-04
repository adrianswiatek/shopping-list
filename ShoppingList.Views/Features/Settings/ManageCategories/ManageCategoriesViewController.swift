import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public final class ManageCategoriesViewController: UIViewController {
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
        configure(.init(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in
            self?.viewModel.restoreCategory()
        })) {
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
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.cleanUp()
    }

    private func setupView() {
        view.backgroundColor = .background

        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(addCategoryTextField)
        NSLayoutConstraint.activate([
            addCategoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addCategoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addCategoryTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: addCategoryTextField.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bind() {
        addCategoryTextField.onAction
            .sink { [weak self] in self?.handleAddListTextFieldAction($0) }
            .store(in: &cancellables)

        tableView.onAction
            .sink { [weak self] in self?.handleTableViewAction($0) }
            .store(in: &cancellables)

        viewModel.categoriesPublisher
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
        let notEmptyRule = ValidationButtonRuleLeaf.notEmptyCategoryRule
        let uniqueRule = ValidationButtonRuleLeaf(
            message: "Category with given name already exists.",
            predicate: { [weak self] in self?.viewModel.hasCategory(with: $0) == true }
        )
        return ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule)
    }

    private func handleTableViewAction(_ action: ManageCategoriesTableView.Action) {
        switch action {
        case .editCategory(let category):
            showEditPopupForCategory(category)
        case .removeCategory(let id):
            viewModel.removeCategory(with: id)
        }
    }

    private func handleAddListTextFieldAction(_ action: TextFieldWithCancel.Action) {
        switch action {
        case .change:
            return // Do nothing
        case let .confirm(text):
            viewModel.addCategory(with: text)
        case let .validationError(text):
            showInfoPopup(with: text)
        }
    }

    private func handleViewModelAction(_ action: ManageCategoriesViewModel.Action) {
        switch action {
        case .showRemoveCategoryPopup(let uuid):
            showRemoveCategoryPopup(forCategoryWith: uuid)
        }
    }

    private func showEditPopupForCategory(_ category: ItemsCategoryViewModel) {
        let controller = PopupWithTextFieldController()
        controller.modalPresentationStyle = .overFullScreen
        controller.popupTitle = "Edit Category Name"
        controller.placeholder = "Enter category name..."
        controller.text = category.name
        controller.saved = { [weak self] in
            self?.viewModel.updateCategory(with: category.uuid, name: $0)
        }
        controller.set(validationButtonRule())
        present(controller, animated: true)
    }

    private func showInfoPopup(with text: String) {
        let controller = UIAlertController(title: "", message: text, preferredStyle: .alert)
        controller.addAction(.init(title: "OK", style: .default))
        present(controller, animated: true)
    }

    private func showRemoveCategoryPopup(forCategoryWith uuid: UUID) {
        let alertMessage = "There are items related with this category. " +
            "If continue, all category items will be swapped to default category."

        let controller = UIAlertController(
            title: "Remove category",
            message: alertMessage,
            preferredStyle: .actionSheet
        )

        controller.addAction(.init(title: "Cancel", style: .cancel))
        controller.addAction(.init(title: "Remove", style: .destructive) { [weak self] _ in
            self?.viewModel.removeCategoryWithItems(with: uuid)
        })

        present(controller, animated: true)
    }

    private func refreshUserInterface() {
        restoreBarButtonItem.isEnabled = viewModel.isRestoreButtonEnabled
        navigationItem.rightBarButtonItem = restoreBarButtonItem
    }
}
