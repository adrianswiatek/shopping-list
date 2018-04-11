import UIKit

extension UITableView {
    func insertRow(at index: Int) {
        self.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func deleteRow(at index: Int, with animation: UITableViewRowAnimation = .automatic) {
        self.deleteRows(at: [IndexPath(row: index, section: 0)], with: animation)
    }
    
    func deleteRows(at indices: [Int], with animation: UITableViewRowAnimation = .automatic) {
        let indexPaths = indices.map { IndexPath(row: $0, section: 0 ) }
        self.deleteRows(at: indexPaths, with: animation)
    }
}
