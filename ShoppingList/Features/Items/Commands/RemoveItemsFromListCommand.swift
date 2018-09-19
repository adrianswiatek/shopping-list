import Foundation

class RemoveItemsFromListCommand: ItemsCommand {
    override func execute(at indexPaths: [IndexPath]) {
        viewController.tableView.deleteRows(at: indexPaths, with: .automatic)
        repository.remove(items)
    }
}
