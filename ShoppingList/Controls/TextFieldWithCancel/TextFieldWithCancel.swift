import UIKit

class TextFieldWithCancel: UIView {
    
    var delegate: TextFieldWithCancelDelegate?
    
    var font: UIFont? {
        get { return textField.font }
        set { textField.font = newValue }
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: UIControl.State.normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.4117647059, blue: 0.8509803922, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(cancelHandler), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func cancelHandler() {
        textField.text = ""
        textField.resignFirstResponder()
        validationButton.alpha = 0
        delegate?.textFieldWithCancelDidCancel?(self)
    }
    
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
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
    
    private var viewController: UIViewController!
    private var validationRule: ValidationButtonRule?
    
    private var cancelButtonAnimations: CancelButtonAnimations!
    private var validationButtonAnimations: ValidationButtonAnimations!
    private var bottomShadowAnimations: BottomShadowAnimations!
    
    // MARK: - Initialize
    
    init(viewController: UIViewController, placeHolder: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: 50))
        
        self.textField.placeholder = placeHolder
        
        self.viewController = viewController
        self.cancelButtonAnimations = CancelButtonAnimations(viewController, cancelButton)
        self.validationButtonAnimations = ValidationButtonAnimations(viewController, validationButton, textField)
        self.bottomShadowAnimations = BottomShadowAnimations(self)
        
        setupUserInterface()
        setupNormalShadow()
    }
    
    private func setupUserInterface() {
        backgroundColor = .white
        
        addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        let cancelButtonTrailingConstraint =
            NSLayoutConstraint(
                item: cancelButton,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,
                multiplier: 1,
                constant: 48)
        
        cancelButtonTrailingConstraint.identifier = "CancelButtonTrailingConstraint"
        cancelButtonTrailingConstraint.isActive = true
        
        addSubview(validationButton)
        validationButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        validationButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8).isActive = true
        validationButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        validationButton.widthAnchor.constraint(equalTo: validationButton.heightAnchor).isActive = true
        
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        let textFieldTrailingConstraint =
            NSLayoutConstraint(
                item: textField,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: cancelButton,
                attribute: .leading,
                multiplier: 1,
                constant: 0)
        
        textFieldTrailingConstraint.identifier = "TextFieldTrailingConstraint"
        textFieldTrailingConstraint.isActive = true
    }
    
    private func setupNormalShadow() {
        bottomShadowAnimations.showNormalShadow()
    }
    
    private func setupEditingShadow() {
        bottomShadowAnimations.showEditShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return true
    }
}

extension TextFieldWithCancel: ButtonValidatable {
    func set(_ validationRule: ValidationButtonRule) {
        self.validationRule = validationRule
    }
    
    func isValid() -> Bool {
        guard let text = textField.text else { return false }
        
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

extension TextFieldWithCancel: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        guard isValid() else { return false }
        
        textField.text = ""
        textField.resignFirstResponder()
        delegate?.textFieldWithCancel?(self, didReturnWith: text)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButtonAnimations.show()
        setupEditingShadow()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButtonAnimations.hide()
        validationButtonAnimations.hide()
        setupNormalShadow()
    }
}
