import UIKit

extension ListsViewController: ItemsViewControllerDelegate {
    func itemsViewControllerDidDismiss(_ itemsViewController: ItemsViewController, with list: List, hasChanges: Bool, previousIndexPath: IndexPath) {
        guard let index = lists.index(where: { $0.id == list.id }), hasChanges else { return }
        
        var updateDelay = 0.0
        
        let newIndexPath = IndexPath(row: index, section: 0)
        if newIndexPath != previousIndexPath {
            tableView.moveRow(at: previousIndexPath, to: newIndexPath)
            updateDelay = 0.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + updateDelay) { [weak self] in
            self?.tableView.reloadRows(at: [newIndexPath], with: .none)
        }
    }
}
