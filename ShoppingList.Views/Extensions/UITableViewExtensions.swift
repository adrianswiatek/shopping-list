import UIKit

extension UITableView {
    public func setBackgroundLabel(_ text: String) {
        let label = UILabel(frame: bounds)
        label.text = text
        label.textColor = .textPrimary
        label.textAlignment = .center
        backgroundView = label
    }
}
