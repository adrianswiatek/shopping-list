import UIKit

extension UIView {
    public func findConstraintWith(identifier: String) -> NSLayoutConstraint? {
        superview?.constraints.first { $0.identifier == identifier }
    }
}
