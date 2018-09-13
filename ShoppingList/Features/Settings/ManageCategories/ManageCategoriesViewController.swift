import UIKit

class ManageCategoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    var categories = [Category]()
    var items = [Item]()
    
    // MARK: - Controls
    
    lazy var addCategoryTextField: TextFieldWithCancel = {
        let textField = TextFieldWithCancel(viewController: self, placeHolder: "Add new category...")
        textField.delegate = self
        textField.set(getValidationButtonRule())
        textField.layer.zPosition = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private func getValidationButtonRule() -> ValidationButtonRule {
        let notEmptyRule = ValidationButtonRuleLeaf.getNotEmptyCategoryRule()
        
        let uniqueRule = ValidationButtonRuleLeaf(
            message: "Category with given name already exists.",
            predicate: { [unowned self] text in self.categories.first { $0.name == text } == nil })
        
        return ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule)
    }
    
    private lazy var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), style: .plain, target: self, action: #selector(restore))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    @objc private func restore() {
        let invoker = CommandInvoker.shared
        if invoker.canUndo(.categories) {
            invoker.undo(.categories)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.register(ManageCategoriesTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        title = "Manage Categories"
        
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(addCategoryTextField)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            addCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addCategoryTextField.topAnchor.constraint(equalTo: view.topAnchor),
            addCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addCategoryTextField.heightAnchor.constraint(equalToConstant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: addCategoryTextField.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCategories()
        fetchItems()
        tableView.reloadData()
        refreshUserInterface()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CommandInvoker.shared.remove(.categories)
    }
    
    func refreshUserInterface() {
        restoreBarButtonItem.isEnabled = CommandInvoker.shared.canUndo(.categories)
        navigationItem.rightBarButtonItem = restoreBarButtonItem
    }
    
    func fetchCategories() {
        var fetchedCategories = Repository.shared.getCategories()
        let defaultCategory = Category.getDefault()
        if fetchedCategories.first(where: { $0.id == defaultCategory.id }) == nil {
            fetchedCategories.append(defaultCategory)
        }
        
        categories = fetchedCategories.sorted { $0.name < $1.name }
    }
    
    func fetchItems() {
        items = Repository.shared.getItems()
    }
}
