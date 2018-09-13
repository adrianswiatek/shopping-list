import Foundation

public class AddAllItemsBackToListCommand: BasketForAllCommand {
    override func execute(at indexPaths: [IndexPath]) {
        viewController.tableView.deleteRows(at: indexPaths, with: .left)
        repository.updateState(of: items, to: .toBuy)
    }
    
    override func undo(at indexPaths: [IndexPath]) {
        viewController.tableView.insertRows(at: indexPaths, with: .left)
        repository.updateState(of: items, to: .inBasket)
    }
}
