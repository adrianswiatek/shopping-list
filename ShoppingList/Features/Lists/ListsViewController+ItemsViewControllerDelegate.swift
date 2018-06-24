import UIKit

extension ListsViewController: ItemsViewControllerDelegate {
    func itemsViewControllerDidDismiss(_ itemsViewController: ItemsViewController, with list: List) {
        guard let index = lists.index(where: { $0.id == list.id }) else { return }
        
        let currentList = lists[index]
        if currentList.getNumberOfItemsToBuy() == list.getNumberOfItemsToBuy() { return }
        
        lists.remove(at: index)
        lists.insert(list, at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
}
