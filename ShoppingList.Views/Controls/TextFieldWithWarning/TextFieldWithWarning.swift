import ShoppingList_Shared
import UIKit

public final class TextFieldWithWarning: UIView {
    public weak var delegate: TextFieldWithWarningDelegate?
    
    public var font: UIFont? {
        get { textField.font }
        set { textField.font = newValue }
    }
    
    public var textColor: UIColor? {
        get { textField.textColor }
        set { textField.textColor = newValue }
    }
    
    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    public var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    public var validationPopupWillAppear: (() -> Void)?
    public var validationPopupWillDisappear: (() -> Void)?
    
    private lazy var textField: UITextField = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        $0.leftViewMode = .always
        $0.delegate = self
    }
    
    private lazy var validationButton: UIButton = configure(.init(type: .system)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "Warning"), for: .normal)
        $0.alpha = 0
        $0.addTarget(self, action: #selector(handleValidation), for: .touchUpInside)
    }
    
    @objc func handleValidation() {
        let alertController = UIAlertController(title: "", message: getValidationMessage(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.validationPopupWillDisappear?()
            self?.textField.becomeFirstResponder()
        }
        
        alertController.addAction(okAction)
        
        validationPopupWillAppear?()
        viewController.present(alertController, animated: true)
    }
    
    private var viewController: UIViewController!
    private var validationButtonAnimations: ValidationButtonAnimations!
    private var validationRule: ValidationButtonRule?
    
    public init(_ viewController: UIViewController) {
        super.init(frame: CGRect.zero)
        
        self.viewController = viewController
        self.validationButtonAnimations = .init(validationButton, textField, self)
        self.setupUserInterface()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
    private func setupUserInterface() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(validationButton)
        NSLayoutConstraint.activate([
            validationButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            validationButton.heightAnchor.constraint(equalToConstant: 20),
            validationButton.widthAnchor.constraint(equalTo: validationButton.heightAnchor),
            validationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let textFieldTrailingConstraint =
            NSLayoutConstraint(
                item: textField,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,
                multiplier: 1,
                constant: 0
            )
        
        textFieldTrailingConstraint.identifier = "TextFieldTrailingConstraint"
        textFieldTrailingConstraint.isActive = true
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
}

extension TextFieldWithWarning: ButtonValidatable {
    public func set(_ validationRule: ValidationButtonRule) {
        self.validationRule = validationRule
    }
    
    public func isValid() -> Bool {
        guard let text = textField.text else { return false }
        
        if validationRule == nil {
            return true
        }
        
        if validationRule?.validate(with: text).isValid == true {
            validationButtonAnimations.hide()
            return true
        }
        
        validationButtonAnimations.show()
        return false
    }
    
    public func getValidationMessage() -> String {
        guard let text = textField.text else { return "" }
        
        if let validatedRule = validationRule?.validate(with: text) {
            return validatedRule.message
        }
        
        return ""
    }
}

extension TextFieldWithWarning: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        guard isValid() else { return false }
        
        delegate?.textFieldWithWarning?(self, didReturnWith: text)
        
        textField.resignFirstResponder()
        
        return true
    }
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let isDirty = text != "" || string != " "
        
        if isDirty {
            validationButtonAnimations.hide()
        }
        
        return isDirty
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validationButtonAnimations.hide()
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        validationButtonAnimations.hide()
        return true
    }
}
