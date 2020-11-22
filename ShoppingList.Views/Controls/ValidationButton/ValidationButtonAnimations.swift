import UIKit

final class ValidationButtonAnimations {
    private var viewController: UIViewController
    private var button: UIButton
    private var textField: UITextField
    
    init(_ viewController: UIViewController, _ button: UIButton, _ textField: UITextField) {
        self.viewController = viewController
        self.button = button
        self.textField = textField
    }
    
    func show() {
        guard button.alpha == 0 else { return }
        
        UIView.animate(
            withDuration: 0.1,
            animations: { [weak self] in
                self?.getTextFieldConstraint()?.constant = -32
                self?.viewController.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                UIView.animate(
                    withDuration: 0.25,
                    animations: { self?.button.alpha = 1
                })
        })
    }
    
    func hide() {
        guard button.alpha == 1 else { return }
        
        UIView.animate(
            withDuration: 0.25,
            animations: { [weak self] in self?.button.alpha = 0 },
            completion: { [weak self] _ in
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.75,
                    initialSpringVelocity: 1,
                    options: .curveEaseOut,
                    animations: {
                        self?.getTextFieldConstraint()?.constant = 0
                        self?.viewController.view.layoutIfNeeded()
                })
        })
    }
    
    private func getTextFieldConstraint() -> NSLayoutConstraint? {
        return textField.findConstraintWith(identifier: "TextFieldTrailingConstraint")
    }
}
