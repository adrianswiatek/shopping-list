import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Basket"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        // Refresh repository
    }
}

// MARK: - UITextFieldDelegate
extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
            guard self != nil else { return }
            
            Repository.ItemsInBasket.remove(at: indexPath.row)
            self!.tableView.deleteRows(at: [indexPath], with: .automatic)
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
        
        Repository.ItemsInBasket.moveItemFromBasket(item)
        tableView.deleteRow(at: itemIndex, with: .left)
    }
}
