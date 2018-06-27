import Foundation

protocol ItemsViewControllerDelegate {
    func itemsViewControllerDidDismiss(
        _ itemsViewController: ItemsViewController,
        with list: List,
        hasChanges: Bool,
        previousIndexPath: IndexPath)
}
