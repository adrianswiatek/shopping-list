import Foundation

final class RemoveItemsFromListCommand: ItemsCommand {
    override func execute(at indexPaths: [IndexPath]) {
        viewController.tableView.deleteRows(at: indexPaths, with: .automatic)
        repository.remove(items)
    }
    
    override func undo(with items: [Item]) {
        repository.add(items)
    }
}
