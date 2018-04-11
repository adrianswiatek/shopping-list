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
    
    func setTextIfEmpty(_ text: String) {
        let label = UILabel(frame: self.bounds)
        label.text = text
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        label.textAlignment = .center
        self.backgroundView = label
    }
}
