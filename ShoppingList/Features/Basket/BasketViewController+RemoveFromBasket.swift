import Foundation

extension BasketViewController: RemoveFromBasketDelegate {
    func removeItemFromBasket(_ item: Item) {
        let command = AddItemsBackToListCommand(item, self)
        CommandInvoker.shared.execute(command)
    }
}
