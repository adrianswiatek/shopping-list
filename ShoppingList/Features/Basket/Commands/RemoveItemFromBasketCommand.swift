import Foundation

class RemoveItemFromBasketCommand: BasketForSingleCommand {
    override func execute(at indexPath: IndexPath) {
        viewController.items.remove(at: indexPath.row)
        viewController.tableView.deleteRows(at: [indexPath], with: .automatic)
        repository.remove(item)
    }
    
    override func undo(at indexPath: IndexPath) {
        viewController.items.insert(item, at: indexPath.row)
        viewController.tableView.insertRows(at: [indexPath], with: .automatic)
        viewController.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        repository.add(item)
    }
}
