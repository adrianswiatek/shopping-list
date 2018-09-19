import Foundation

class AddItemsToBasketCommand: ItemsCommand {

    override func execute(at indexPaths: [IndexPath]) {
        viewController.tableView.deleteRows(at: indexPaths, with: .right)
        repository.updateState(of: items, to: .inBasket)
    }
}
