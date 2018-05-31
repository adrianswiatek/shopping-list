import UIKit

extension UITableView {
    func setTextIfEmpty(_ text: String) {
        let label = UILabel(frame: self.bounds)
        label.text = text
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        label.textAlignment = .center
        self.backgroundView = label
    }
}
