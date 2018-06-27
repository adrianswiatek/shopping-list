import Foundation

extension BasketViewController: RemoveFromBasketDelegate {
    func removeItemFromBasket(_ item: Item) {
        guard let index = items.index(where: { $0.id == item.id }) else { return }
        
        items.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        
        Repository.shared.updateState(of: item, to: .toBuy)
        Repository.shared.setItemsOrder(items, in: list, forState: .inBasket)
        
        refreshScene()
    }
}
