import UIKit

class ItemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewItemTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    private var cancelButtonAnimations: CancelButtonAnimations!

    private var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButtonAnimations = CancelButtonAnimations(viewController: self)
        
        items.append("Bananas")
        items.append("Newspaper")
        items.append("Food for dog")
        items.append("Vacuum cleaner")
    }

    @IBAction func addItemTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func basketTapped(_ sender: UIBarButtonItem) {
        
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
        return UISwipeActionsConfiguration(actions: [editItemAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
            guard self != nil else { return }
            
            self!.items.remove(at: indexPath.row)
            self!.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteItemAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }
}

// MARK: - UITableViewDataSource
extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.itemNameLabel.text = items[indexPath.row]
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension ItemsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return false }

        items.insert(text, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButtonAnimations.show()
        backgroundView.alpha = 0.5
        //tableView.alpha = 0.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButtonAnimations.hide()
        backgroundView.alpha = 0
        //tableView.alpha = 1
    }
}
