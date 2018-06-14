import UIKit

class ManageCategoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    var categories = [Category]()
    var items = [Item]()
    
    // MARK: - Controls
    
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
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
