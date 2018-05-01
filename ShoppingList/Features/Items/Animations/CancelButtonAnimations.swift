import UIKit

class CancelButtonAnimations {
    
    private weak var viewController: ItemsViewController!
    private weak var button: UIButton!
    
    private var constraint: NSLayoutConstraint?
    
    init(viewController: ItemsViewController) {
        self.viewController = viewController
        self.button = viewController.cancelAddingItemButton
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
