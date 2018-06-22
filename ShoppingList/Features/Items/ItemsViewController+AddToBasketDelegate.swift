import Foundation

extension ItemsViewController: AddToBasketDelegate {
    func addItemToBasket(_ item: Item) {
        guard let section = categories.index(where: { $0.id == item.getCategory().id }) else {
            fatalError("Unable to find index of the category.")
        }
        
        guard let row = items[section].index(where: { $0.id == item.id }) else {
            fatalError("Unable to find index of the item.")
        }
        
        items[section].remove(at: row)
        tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .right)
        
        Repository.shared.updateState(of: item, to: .inBasket)
        Repository.shared.setItemsOrder(self.items.flatMap { $0 }, forState: .toBuy)
        
        refreshScene()
    }
}
