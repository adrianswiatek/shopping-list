import UIKit

public final class ValidationButtonAnimations {
    private let button: UIButton
    private let textField: UITextField
    private let view: UIView

    private var textFieldConstraint: NSLayoutConstraint? {
        textField.findConstraintWith(identifier: "TextFieldTrailingConstraint")
    }
    
    public init(_ button: UIButton, _ textField: UITextField, _ view: UIView) {
        self.button = button
        self.textField = textField
        self.view = view
    }
    
    public func show() {
        guard button.alpha == 0 else { return }
        
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.textFieldConstraint?.constant = -32
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.25,
                    animations: { self.button.alpha = 1 }
                )
            }
        )
    }
    
    public func hide() {
        guard button.alpha == 1 else { return }
        
        UIView.animate(
            withDuration: 0.25,
            animations: { self.button.alpha = 0 },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.75,
                    initialSpringVelocity: 1,
                    options: .curveEaseOut,
                    animations: {
                        self.textFieldConstraint?.constant = 0
                        self.view.layoutIfNeeded()
                    }
                )
            }
        )
    }
}
