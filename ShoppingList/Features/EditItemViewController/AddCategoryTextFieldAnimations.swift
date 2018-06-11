import UIKit

class AddCategoryTextFieldAnimations {
    
    private let viewController: UIViewController
    private let textField: TextFieldWithCancel
    private let button: UIButton
    
    init(
        _ viewController: UIViewController,
        _ addCategoryTextField: TextFieldWithCancel,
        _ addCategoryButton: UIButton) {
        self.viewController = viewController
        self.textField = addCategoryTextField
        self.button = addCategoryButton
    }
    
    func show() {
        getAddCategoryTopConstraint()?.constant = 0
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.viewController.view.layoutIfNeeded()
                self?.button.alpha = 0
            }, completion: { [weak self] _ in
                self?.textField.becomeFirstResponder()
        })
    }
    
    func hide() {
        getAddCategoryTopConstraint()?.constant = -50
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.viewController.view.layoutIfNeeded()
            self?.button.alpha = 1
        })
    }
    
    private func getAddCategoryTopConstraint() -> NSLayoutConstraint? {
        return textField.superview?.constraints.first { $0.identifier == "AddCategoryTextFieldTopConstraint" }
    }
}
