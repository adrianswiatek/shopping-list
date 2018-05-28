import UIKit

class ItemsViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var addItemTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add new item..."
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var cancelAddingItemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.4117647059, blue: 0.8509803922, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(cancelAddingItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(editList))
    }()
    
    lazy var actionButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActions))
    }()
    
    lazy var regularToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.setItems([
            editButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            actionButton,
            ], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    var items = [Item]()
    var categoryNames = [String]()
    
    var cancelButtonAnimations: CancelButtonAnimations!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        cancelButtonAnimations = CancelButtonAnimations(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchItems()
        tableView.reloadData()
        
        refreshScene()
    }
    
    func fetchItems() {
        items = Repository.shared.getItemsWith(state: .toBuy)
        categoryNames = items.map { $0.getCategoryName() }.sorted()
    }
    
    private func setupUserInterface() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: #imageLiteral(resourceName: "Basket"), style: .plain, target: self, action: #selector(goToBasketScene))

        view.addSubview(regularToolbar)
        regularToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        regularToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        regularToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        regularToolbar.heightAnchor.constraint(equalToConstant: 50)
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: regularToolbar.topAnchor).isActive = true
    }
    
    @objc private func editList() {
        
    }
    
    @objc private func showActions() {
        
    }
    
    @objc private func goToBasketScene() {
        let basketViewController = BasketViewController()
        navigationController?.pushViewController(basketViewController, animated: true)
    }
    
    @objc private func cancelAddingItem() {
        addItemTextField.text = ""
        addItemTextField.resignFirstResponder()
    }
    
    func refreshScene() {
        if items.count > 0 {
            tableView.backgroundView = nil
        } else {
            tableView.setTextIfEmpty("Your shopping list is empty")
        }
    }
}
