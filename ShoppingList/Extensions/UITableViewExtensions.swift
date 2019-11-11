import UIKit

extension UITableView {
    func setTextIfEmpty(_ text: String) {
        let label = UILabel(frame: self.bounds)
        label.text = text
        label.textColor = .textPrimary
        label.textAlignment = .center
        self.backgroundView = label
    }
}
