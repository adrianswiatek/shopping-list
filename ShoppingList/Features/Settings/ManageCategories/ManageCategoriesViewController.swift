import UIKit

class ManageCategoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    var categories = [Category]()
    var items = [Item]()
    
    // MARK: - Controls
    
    lazy var addCategoryTextField: TextFieldWithCancel = {
        let textFieldWithCancel = TextFieldWithCancel(viewController: self, placeHolder: "Add new category...")
        textFieldWithCancel.delegate = self
        textFieldWithCancel.layer.zPosition = 1
        textFieldWithCancel.translatesAutoresizingMaskIntoConstraints = false
        return textFieldWithCancel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.register(ManageCategoriesTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        title = "Manage Categories"
        
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(addCategoryTextField)
        addCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addCategoryTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addCategoryTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: addCategoryTextField.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCategories()
        fetchItems()
        tableView.reloadData()
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
