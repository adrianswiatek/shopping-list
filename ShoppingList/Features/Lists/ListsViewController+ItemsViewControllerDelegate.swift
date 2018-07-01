import UIKit

extension ListsViewController: ItemsViewControllerDelegate {
    func itemsViewControllerDidDismiss(_ itemsViewController: ItemsViewController) {
        fetchLists()
        tableView.reloadData()
    }
}
