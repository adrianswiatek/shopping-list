import Foundation

class RemoveItemFromListCommand: ItemsCommand {
    override init(_ item: Item, _ viewController: ItemsViewController) {
        super.init(item, viewController)
    }
    
    override func execute(at indexPath: IndexPath) {
        viewController.items[indexPath.section].remove(at: indexPath.row)
        viewController.tableView.deleteRows(at: [indexPath], with: .automatic)
        repository.remove(item)
    }
    
    override func undo(at indexPath: IndexPath) {
        viewController.items[indexPath.section].insert(item, at: indexPath.row)
        viewController.tableView.insertRows(at: [indexPath], with: .automatic)
        viewController.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        repository.add(item)
    }
}
