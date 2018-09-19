import Foundation

extension ItemsViewController: AddToBasketDelegate {
    func addItemToBasket(_ item: Item) {
        let command = AddItemsToBasketCommand(item, self)
        CommandInvoker.shared.execute(command)
    }
}
