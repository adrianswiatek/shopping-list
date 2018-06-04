import UIKit

class AddItemView: UIView, UITextFieldDelegate {
    
    var delegate: AddItemViewDelegate?
    
    private lazy var addItemTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add new item..."
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var cancelAddingItemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: UIControl.State.normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.4117647059, blue: 0.8509803922, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(cancelAddingItem), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func cancelAddingItem() {
        addItemTextField.text = ""
        addItemTextField.resignFirstResponder()
    }
    
    private var cancelButtonAnimations: CancelButtonAnimations!
    
    // MARK: - Initialize
    
    init(viewController: UIViewController) {
        super.init(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: 50))
        cancelButtonAnimations = CancelButtonAnimations(viewController: viewController, button: cancelAddingItemButton)
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        addSubview(cancelAddingItemButton)
        cancelAddingItemButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cancelAddingItemButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cancelAddingItemButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        let cancelButtonTrailingConstraint =
            NSLayoutConstraint(
                item: cancelAddingItemButton,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,
                multiplier: 1,
                constant: 48)
        
        cancelButtonTrailingConstraint.identifier = "CancelButtonTrailingConstraint"
        cancelButtonTrailingConstraint.isActive = true
        
        addSubview(addItemTextField)
        addItemTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        addItemTextField.rightAnchor.constraint(equalTo: cancelAddingItemButton.leftAnchor).isActive = true
        addItemTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        addItemTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return false }
        delegate?.addItemTextField(textField, didReturnWith: text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButtonAnimations.show()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButtonAnimations.hide()
    }
}
