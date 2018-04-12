import UIKit

class BottomToolbarAnimations {
    
    private weak var viewController: BasketViewController!
    
    private var constraint: NSLayoutConstraint?
    private let animator: UIViewPropertyAnimator
    
    private let shownPosition: CGFloat = 0
    private let hiddenPosition: CGFloat = 44
    
    init(viewController: BasketViewController) {
        self.viewController = viewController
        self.constraint = viewController.bottomToolbar.findConstraintWith(identifier: "BottomToolbarConstraint")
        self.animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5)
    }
    
    func show() {
        guard let constraint = constraint, constraint.constant != shownPosition else { return }
        
        constraint.constant = shownPosition
        animator.addAnimations { [weak self] in self?.viewController.view.layoutIfNeeded() }
        animator.startAnimation()
    }
    
    func hide() {
        guard let constraint = constraint, constraint.constant != hiddenPosition else { return }
        
        constraint.constant = hiddenPosition
        animator.addAnimations { [weak self] in self?.viewController.view.layoutIfNeeded() }
        animator.startAnimation()
    }
}
