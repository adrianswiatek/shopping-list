import UIKit

class CancelButtonAnimations {
    
    private weak var viewController: ItemsViewController!
    private weak var cancelButton: UIButton!
    
    private var cancelButtonTrailingConstraint: NSLayoutConstraint?
    
    init(viewController: ItemsViewController) {
        self.viewController = viewController
        self.cancelButton = viewController.cancelButton
        self.cancelButtonTrailingConstraint = cancelButton
            .findConstraintWith(identifier: "CancelButtonTrailingConstraint")
    }
    
    func show() {
        cancelButtonTrailingConstraint?.constant = 16
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: { [weak self] in self?.viewController.view.layoutIfNeeded() })
    }
    
    func hide() {
        cancelButtonTrailingConstraint?.constant = -cancelButton.frame.width
        UIView.animate(withDuration: 0.25) { [weak self] in self?.viewController.view.layoutIfNeeded() }
    }
}
