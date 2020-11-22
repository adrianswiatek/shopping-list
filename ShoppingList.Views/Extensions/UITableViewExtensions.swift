import UIKit

extension UITableView {
    public func setTextIfEmpty(_ text: String) {
        let label = UILabel(frame: bounds)
        label.text = text
        label.textColor = .textPrimary
        label.textAlignment = .center
        backgroundView = label
    }
}
