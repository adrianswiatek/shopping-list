import UIKit

class ItemsViewController: UITableViewController {
    
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
    
    var cancelButtonAnimations: CancelButtonAnimations!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        cancelButtonAnimations = CancelButtonAnimations(viewController: self)
        
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        refreshScene()
    }
    
    private func setupUserInterface() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: #imageLiteral(resourceName: "Basket"), style: .plain, target: self, action: #selector(goToBasketScene))
        
        tableView.separatorStyle = .none
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
        if Repository.ItemsToBuy.any {
            tableView.backgroundView = nil
        } else {
            tableView.setTextIfEmpty("Your shopping list is empty")
        }
    }
}
