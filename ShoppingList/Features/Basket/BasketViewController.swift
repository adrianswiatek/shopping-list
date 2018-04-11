import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionButtons: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Basket"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        refreshScene()
        // Refresh repository
    }
    
    private func refreshScene() {
        if Repository.ItemsInBasket.any {
            actionButtons.isEnabled = true
            tableView.backgroundView = nil
        } else {
            actionButtons.isEnabled = false
            tableView.setTextIfEmpty("Your basket is empty")
        }
    }
    
    @IBAction func actionTapped(_ sender: UIBarButtonItem) {
        let restoreAllAction = UIAlertAction(title: "Restore all", style: .default) { [weak self] action in
            guard self != nil else { return }
            
            let restoredItems = Repository.ItemsInBasket.restoreAll()
            let indicesOfRestoredItems = (0..<restoredItems.count).map { $0 }
            self!.tableView.deleteRows(at: indicesOfRestoredItems, with: .left)
            self!.refreshScene()
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [weak self] action in
            guard self != nil else { return }
            
            let removedItems = Repository.ItemsInBasket.removeAll()
            let indicesOfRemovedItems = (0..<removedItems.count).map { $0 }
            self!.tableView.deleteRows(at: indicesOfRemovedItems)
            self!.refreshScene()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(restoreAllAction)
        alertController.addAction(deleteAllAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
            guard self != nil else { return }
            
            Repository.ItemsInBasket.remove(at: indexPath.row)
            self!.tableView.deleteRows(at: [indexPath], with: .automatic)
            self!.refreshScene()
            completionHandler(true)
        }
        deleteItemAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        deleteItemAction.image = #imageLiteral(resourceName: "Trash")
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }
}

// MARK: - UITextFieldDataSource
extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.ItemsInBasket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BasketTableViewCell
        
        if let item = Repository.ItemsInBasket.getItem(at: indexPath.row) {
            cell.initialize(item: item, delegate: self)
            cell.itemNameLabel.text = item.name
        }
        
        return cell
    }
}

// MARK: - RemoveFromBasketDelegate
extension BasketViewController: RemoveFromBasketDelegate {
    func removeItemFromBasket(_ item: Item) {
        guard let itemIndex = Repository.ItemsInBasket.getIndexOf(item) else { return }
        
        Repository.ItemsInBasket.restoreItem(item)
        tableView.deleteRow(at: itemIndex, with: .left)
        refreshScene()
    }
}
