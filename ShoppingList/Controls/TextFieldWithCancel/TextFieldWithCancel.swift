import UIKit

class TextFieldWithCancel: UIView, UITextFieldDelegate {
    
    var delegate: TextFieldWithCancelDelegate?
    
    var font: UIFont? {
        get {
            return textField.font
        }
        set {
            textField.font = newValue
        }
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
        button.addTarget(self, action: #selector(cancelHandler), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func cancelHandler() {
        textField.text = ""
        textField.resignFirstResponder()
        delegate?.textFieldWithCancelDidCancel?(self)
    }
    
    private var cancelButtonAnimations: CancelButtonAnimations!
    private var bottomShadowAnimations: BottomShadowAnimations!
    
    // MARK: - Initialize
    
    init(viewController: UIViewController, placeHolder: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: 50))
        textField.placeholder = placeHolder
        
        cancelButtonAnimations = CancelButtonAnimations(viewController: viewController, button: cancelButton)
        bottomShadowAnimations = BottomShadowAnimations(view: self)
        
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
        
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
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
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return false }
        textField.text = ""
        textField.resignFirstResponder()
        delegate?.textFieldWithCancel?(self, didReturnWith: text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButtonAnimations.show()
        setupEditingShadow()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButtonAnimations.hide()
        setupNormalShadow()
    }
}
