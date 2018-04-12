import UIKit

class CancelButtonAnimations {
    
    private weak var viewController: ItemsViewController!
    private weak var button: UIButton!
    
    private var constraint: NSLayoutConstraint?
    
    init(viewController: ItemsViewController) {
        self.viewController = viewController
        self.button = viewController.cancelButton
        self.constraint = button.findConstraintWith(identifier: "CancelButtonTrailingConstraint")
    }
    
    func show() {
        constraint?.constant = 16
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: { [weak self] in self?.viewController.view.layoutIfNeeded() })
    }
    
    func hide() {
        constraint?.constant = -button.frame.width
        UIView.animate(withDuration: 0.25) { [weak self] in self?.viewController.view.layoutIfNeeded() }
    }
}
