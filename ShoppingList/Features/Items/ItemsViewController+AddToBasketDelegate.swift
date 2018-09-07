import Foundation

extension ItemsViewController: AddToBasketDelegate {
    func addItemToBasket(_ item: Item) {
        let command = AddItemToBasketCommand(item, self)
        CommandInvoker.shared.execute(command)
    }
}
