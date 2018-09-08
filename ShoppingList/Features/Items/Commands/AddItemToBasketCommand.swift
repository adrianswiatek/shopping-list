import Foundation

class AddItemToBasketCommand: ItemsCommand {
    override func execute(at indexPath: IndexPath) {
        viewController.items[indexPath.section].remove(at: indexPath.row)
        viewController.tableView.deleteRows(at: [indexPath], with: .right)
        repository.updateState(of: item, to: .inBasket)
    }
    
    override func undo(at indexPath: IndexPath) {
        viewController.items[indexPath.section].insert(item, at: indexPath.row)
        viewController.tableView.insertRows(at: [indexPath], with: .right)
        viewController.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        repository.updateState(of: item, to: .toBuy)
    }
}
