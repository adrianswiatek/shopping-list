import UIKit

class ItemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewItemTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    private var cancelButtonAnimations: CancelButtonAnimations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButtonAnimations = CancelButtonAnimations(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        // Refresh repository
    }
    
    @IBAction func addItemTapped(_ sender: UIBarButtonItem) {
        // Go to add new item scene
    }
    
    @IBAction func basketTapped(_ sender: UIBarButtonItem) {
        // Go to basket scene
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        addNewItemTextField.text = ""
        addNewItemTextField.resignFirstResponder()
    }
}

// MARK - UITableViewDelegate
extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editItemAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, sourceView, completionHandler) in
            guard self != nil else { return }
            
            completionHandler(true)
        }
        editItemAction.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        editItemAction.image = #imageLiteral(resourceName: "Edit")
        return UISwipeActionsConfiguration(actions: [editItemAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
            guard self != nil else { return }
            
            let row = indexPath.row
            Repository.ItemsToBuy.remove(at: row)
            self!.tableView.deleteRow(at: row)
            completionHandler(true)
        }
        deleteItemAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        deleteItemAction.image = #imageLiteral(resourceName: "Trash")
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }
}

// MARK: - UITableViewDataSource
extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.ItemsToBuy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        if let item = Repository.ItemsToBuy.getItem(at: indexPath.row) {
            cell.initialize(item: item, delegate: self)
            cell.itemNameLabel.text = item.name
        }
        
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension ItemsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return false }

        Repository.addNew(item: Item.toBuy(name: text))
        tableView.insertRow(at: 0)

        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButtonAnimations.show()
        backgroundView.alpha = 0.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButtonAnimations.hide()
        backgroundView.alpha = 0
    }
}

// MARK: - AddToBasketDelegate
extension ItemsViewController: AddToBasketDelegate {
    func addItemToBasket(_ item: Item) {
        guard let itemIndex = Repository.ItemsToBuy.getIndexOf(item) else { return }
        
        Repository.ItemsToBuy.moveItemToBasket(item)
        tableView.deleteRow(at: itemIndex, with: .right)
    }
}
