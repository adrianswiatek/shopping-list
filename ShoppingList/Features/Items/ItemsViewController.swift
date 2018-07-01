import UIKit

class ItemsViewController: UIViewController {
    
    var delegate: ItemsViewControllerDelegate!
    
    var list: List!
    var listIndexPath: IndexPath!
    
    var items = [[Item]]()
    var categories = [Category]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.dragInteractionEnabled = true
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var addItemTextField: TextFieldWithCancel = {
        let textFieldWithCancel = TextFieldWithCancel(viewController: self, placeHolder: "Add new item...")
        textFieldWithCancel.delegate = self
        textFieldWithCancel.layer.zPosition = 1
        textFieldWithCancel.translatesAutoresizingMaskIntoConstraints = false
        return textFieldWithCancel
    }()
    
    lazy var toolbar: ItemsToolbar = {
        let toolbar = ItemsToolbar(viewController: self)
        toolbar.delegate = self
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    lazy var goToFilledBasketBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "Basket"), style: .plain, target: self, action: #selector(goToBasketScene))
    }()
    
    lazy var goToEmptyBasketBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "EmptyBasket"), style: .plain, target: self, action: #selector(goToBasketScene))
    }()
    
    @objc private func goToBasketScene() {
        let basketViewController = BasketViewController()
        basketViewController.list = list
        navigationController?.pushViewController(basketViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateStartingContract()
        setupUserInterface()
    }
    
    private func validateStartingContract() {
        guard delegate != nil, list != nil, listIndexPath != nil else {
            fatalError("Found nil in starting contract.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchItems()
        tableView.reloadData()
        
        refreshUserInterface()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate.itemsViewControllerDidDismiss(self)
    }
    
    func fetchItems() {
        let allItems = Repository.shared.getItemsWith(state: .toBuy, in: list)
        var items = [[Item]]()
        self.categories = Set(allItems.map { $0.category ?? Category.getDefault() }).sorted { $0.name < $1.name }
        
        for category in categories {
            let itemsInCategory = allItems.filter { $0.getCategoryName() == category.name }
            items.append(itemsInCategory)
        }
        
        self.items = items
    }
    
    private func setupUserInterface() {
        view.backgroundColor = .white
        
        navigationItem.title = list.name

        view.addSubview(addItemTextField)
        addItemTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        addItemTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        addItemTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        addItemTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(toolbar)
        toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50)
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: addItemTextField.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
    }
    
    func refreshUserInterface(after: Double = 0) {
        setGoToBasketButton()
        
        items.count > 0 ? self.setSceneAsEditable() : self.setSceneAsNotEditable()
        tableView.setEditing(false, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after) { [unowned self] in
            self.clearCategoriesIfNeeded()
        }
    }
    
    func setGoToBasketButton() {
        let numberOfItemsInBasket = Repository.shared.getNumberOfItemsWith(state: .inBasket, in: list)
        navigationItem.rightBarButtonItem =
            numberOfItemsInBasket > 0 ? goToFilledBasketBarButtonItem : goToEmptyBasketBarButtonItem
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
            let range = 0..<categories.count
            categories.removeAll()
            tableView.deleteSections(IndexSet(range), with: .middle)
        } else {
            for (index, itemsInCategory) in items.enumerated().sorted(by: { $0.offset > $1.offset }) {
                if itemsInCategory.count == 0 {
                    items.remove(at: index)
                    categories.remove(at: index)
                    tableView.deleteSections(IndexSet(integer: index), with: .middle)
                }
            }
        }
    }
    
    func goToEditItemDetailed(with item: Item? = nil) {
        let viewController = EditItemViewController()
        viewController.delegate = self
        viewController.list = list
        viewController.item = item
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        
        present(navigationController, animated: true)
    }
}
