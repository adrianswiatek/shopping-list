import Foundation

extension ItemsViewController: AddToBasketDelegate {
    func addItemToBasket(_ item: Item) {
        guard
            let section = categories.index(where: { $0 == item.category }),
            let row = items[section].index(where: { $0.id == item.id })
        else { return }
        
        items[section].remove(at: row)
        tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .right)
        Repository.shared.updateState(of: item, to: .inBasket)
        
        refreshScene()
    }
}
