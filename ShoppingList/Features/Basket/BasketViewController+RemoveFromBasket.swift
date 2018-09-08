import Foundation

extension BasketViewController: RemoveFromBasketDelegate {
    func removeItemFromBasket(_ item: Item) {
        let command = AddItemBackToListCommand(item, self)
        CommandInvoker.shared.execute(command)
    }
}
