import UIKit

extension UIView {
    func findConstraintWith(identifier: String) -> NSLayoutConstraint? {
        return self.superview?.constraints.first { $0.identifier == identifier }
    }
}
