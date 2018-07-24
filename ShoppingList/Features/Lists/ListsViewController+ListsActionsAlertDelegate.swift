import UIKit

extension ListsViewController: ListsActionsAlertDelegate {
    func deleteAllItemsIn(_ list: List) {
        remove(items: list.items, from: list)
    }
    
    func emptyBasketIn(_ list: List) {
        remove(items: list.items.filter { $0.state == .inBasket }, from: list)
    }
    
    private func remove(items: [Item], from list: List) {
        guard let index = lists.index(where: { $0.id == list.id }) else { return }

        Repository.shared.remove(items)
        
        guard let removedList = Repository.shared.getList(by: list.id) else { return }
        lists.remove(at: index)
        lists.insert(removedList, at: 0)
        
        let indexPath = IndexPath(row: index, section: 0)
        
        if index == 0 {
            tableView.reloadRows(at: [indexPath], with: .middle)
        } else {
            let zeroIndexPath = IndexPath(row: 0, section: 0)
            tableView.moveRow(at: indexPath, to: zeroIndexPath)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.tableView.reloadRows(at: [zeroIndexPath], with: .middle)
            }
        }
    }
}
