import UIKit

class CancelButtonAnimations {
    
    private var viewController: UIViewController
    private var button: UIButton
    
    private var constraint: NSLayoutConstraint?
    
    init(viewController: UIViewController, button: UIButton) {
        self.viewController = viewController
        self.button = button
    }
    
    func show() {
        getConstraint()?.constant = -12
        UIView.animate(
            withDuration: 0.75,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: { [weak self] in self?.viewController.view.layoutIfNeeded() })
    }
    
    func hide() {
        getConstraint()?.constant = 48
        UIView.animate(withDuration: 0.25) { [weak self] in self?.viewController.view.layoutIfNeeded() }
    }
    
    private func getConstraint() -> NSLayoutConstraint? {
        return button.findConstraintWith(identifier: "CancelButtonTrailingConstraint")
    }
}
