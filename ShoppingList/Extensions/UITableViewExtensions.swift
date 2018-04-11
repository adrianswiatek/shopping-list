import UIKit

extension UITableView {
    func insertRow(at index: Int) {
        self.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func deleteRow(at index: Int, with animation: UITableViewRowAnimation = .automatic) {
        self.deleteRows(at: [IndexPath(row: index, section: 0)], with: animation)
    }
}
