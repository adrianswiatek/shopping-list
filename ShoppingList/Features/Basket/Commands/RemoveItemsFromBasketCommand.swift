import Foundation

final class RemoveItemsFromBasketCommand: BasketCommand {
    override func execute(at indexPaths: [IndexPath]) {
        viewController.tableView.deleteRows(at: indexPaths, with: .automatic)
        repository.remove(items)
    }
    
    override func undo(at indexPaths: [IndexPath]) {
        viewController.tableView.insertRows(at: indexPaths, with: .automatic)
        repository.add(items)
    }
}
