import UIKit

extension UITableView {
    func insertRow(at index: Int) {
        self.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func deleteRow(at index: Int) {
        self.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
