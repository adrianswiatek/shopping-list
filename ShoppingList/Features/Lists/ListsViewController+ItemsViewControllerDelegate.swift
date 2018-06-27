import UIKit

extension ListsViewController: ItemsViewControllerDelegate {
    func itemsViewControllerDidDismiss(_ itemsViewController: ItemsViewController, with list: List, hasChanges: Bool, previousIndexPath: IndexPath) {
        guard let index = lists.index(where: { $0.id == list.id }), hasChanges else { return }
        
        var rowUpdateDelay = 0.0
        
        let newIndexPath = IndexPath(row: index, section: 0)
        if newIndexPath != previousIndexPath {
            tableView.moveRow(at: previousIndexPath, to: newIndexPath)
            rowUpdateDelay = 0.4
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + rowUpdateDelay) { [weak self] in
            self?.tableView.reloadRows(at: [newIndexPath], with: .middle)
        }
    }
}
