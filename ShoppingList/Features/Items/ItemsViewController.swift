import UIKit

class ItemsViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var addItemView: AddItemView = {
        let addItemView = AddItemView(viewController: self)
        addItemView.delegate = self
        addItemView.translatesAutoresizingMaskIntoConstraints = false
        return addItemView
    }()
    
    lazy var toolbar: ItemsToolbar = {
        let toolbar = ItemsToolbar(viewController: self)
        toolbar.delegate = self
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    var items = [[Item]]()
    var categoryNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchItems()
        tableView.reloadData()
        
        refreshScene()
    }
    
    func fetchItems() {
        let allItems = Repository.shared.getItemsWith(state: .toBuy)
        var items = [[Item]]()
        self.categoryNames = Set(allItems.map { $0.getCategoryName() }).sorted()
        
        for categoryName in categoryNames {
            let itemsInCategory = allItems.filter { $0.getCategoryName() == categoryName }
            items.append(itemsInCategory)
        }
        
        self.items = items
    }
    
    private func setupUserInterface() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: #imageLiteral(resourceName: "Basket"), style: .plain, target: self, action: #selector(goToBasketScene))

        view.addSubview(addItemView)
        addItemView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addItemView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addItemView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addItemView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(toolbar)
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50)
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: addItemView.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
    }
    
    @objc private func goToBasketScene() {
        let basketViewController = BasketViewController()
        navigationController?.pushViewController(basketViewController, animated: true)
    }
    
    func refreshScene(after: Double = 0) {
        items.count > 0 ? self.setSceneAsEditable() : self.setSceneAsNotEditable()
        tableView.setEditing(false, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after) { [unowned self] in
            self.clearCategoriesIfNeeded()
        }
    }
    
    private func setSceneAsEditable() {
        toolbar.setRegularMode()
        toolbar.setButtonsAs(enabled: true)
        tableView.backgroundView = nil
    }
    
    private func setSceneAsNotEditable() {
        toolbar.setRegularMode()
        toolbar.setButtonsAs(enabled: false)
        tableView.setTextIfEmpty("Your shopping list is empty")
    }
    
    private func clearCategoriesIfNeeded() {
        if items.count == 0 {
            let range = 0..<categoryNames.count
            categoryNames.removeAll()
            tableView.deleteSections(IndexSet(range), with: .middle)
        } else {
            for (index, itemsInCategory) in items.enumerated().sorted(by: { $0.offset > $1.offset }) {
                if itemsInCategory.count == 0 {
                    items.remove(at: index)
                    categoryNames.remove(at: index)
                    tableView.deleteSections(IndexSet(integer: index), with: .middle)
                }
            }
        }
    }
}
