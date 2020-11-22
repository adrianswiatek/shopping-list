import UIKit

final class InfoForEditItem: UIView {
    weak var delegate: InfoForEditItemDelegate?
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "INFO:"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter additional info..."
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 17)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface() {
        backgroundColor = .white
        
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: EditItemViewController.labelsLeftPadding).isActive = true
        label.widthAnchor.constraint(equalToConstant: EditItemViewController.labelsWidth).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}
