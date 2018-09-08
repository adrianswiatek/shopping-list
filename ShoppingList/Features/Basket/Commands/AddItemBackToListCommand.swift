import Foundation

class AddItemBackToListCommand: BasketCommand {
    override func execute(at indexPath: IndexPath) {
        viewController.items.remove(at: indexPath.row)
        viewController.tableView.deleteRows(at: [indexPath], with: .left)
        repository.updateState(of: item, to: .toBuy)
    }
    
    override func undo(at indexPath: IndexPath) {
        viewController.items.insert(item, at: indexPath.row)
        viewController.tableView.insertRows(at: [indexPath], with: .left)
        viewController.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        repository.updateState(of: item, to: .inBasket)
    }
}
