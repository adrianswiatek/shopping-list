import UIKit

public final class CancelButtonAnimations {
    private let button: UIButton
    private let view: UIView

    private var constraint: NSLayoutConstraint? {
        button.findConstraintWith(identifier: "CancelButtonTrailingConstraint")
    }
    
    public init(_ button: UIButton, _ view: UIView) {
        self.button = button
        self.view = view
    }
    
    public func show() {
        constraint?.constant = -12
        UIView.animate(
            withDuration: 0.75,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: { self.view.layoutIfNeeded() }
        )
    }
    
    public func hide() {
        constraint?.constant = 48
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }
}
