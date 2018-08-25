import UIKit

class TextFieldWithWarning: UIView {
    
    weak var delegate: UITextFieldDelegate?
    
    var font: UIFont? {
        get { return textField.font }
        set { textField.font = newValue }
    }
    
    var textColor: UIColor? {
        get { return textField.textColor }
        set { textField.textColor = newValue }
    }
    
    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        textField.delegate = self
        delegate = textField.delegate
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var validationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "warning"), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(handleValidation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleValidation() {
        let alertController = UIAlertController(
            title: "",
            message: getValidationMessage(),
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.textField.becomeFirstResponder()
        }
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
    
    private var viewController: UIViewController!
    private var validationButtonAnimations: ValidationButtonAnimations!
    private var validationRule: ValidationButtonRule?
    
    init(_ viewController: UIViewController) {
        super.init(frame: CGRect.zero)
        
        self.viewController = viewController
        self.validationButtonAnimations =
            ValidationButtonAnimations(viewController, validationButton, textField)

        self.setupUserInterface()
    }
    
    private func setupUserInterface() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(validationButton)
        validationButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        validationButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        validationButton.widthAnchor.constraint(equalTo: validationButton.heightAnchor).isActive = true
        validationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let textFieldTrailingConstraint =
            NSLayoutConstraint(
                item: textField,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,
                multiplier: 1,
                constant: 0)
        
        textFieldTrailingConstraint.identifier = "TextFieldTrailingConstraint"
        textFieldTrailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}

extension TextFieldWithWarning: ButtonValidatable {
    func set(_ validationRule: ValidationButtonRule) {
        self.validationRule = validationRule
    }
    
    func isValid() -> Bool {
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
    
    func getValidationMessage() -> String {
        guard let text = textField.text else { return "" }
        
        if let validatedRule = validationRule?.validate(with: text) {
            return validatedRule.message
        }
        
        return ""
    }
}

extension TextFieldWithWarning: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard isValid() else { return false }
        
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
    func textField(
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validationButtonAnimations.hide()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        validationButtonAnimations.hide()
        return true
    }
}
