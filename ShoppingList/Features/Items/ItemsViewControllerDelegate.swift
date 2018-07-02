import Foundation

protocol ItemsViewControllerDelegate {
    func itemsViewControllerDidDismiss(_ itemsViewController: ItemsViewController, withUpdated lists: [List])
}
