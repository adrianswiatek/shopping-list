import UIKit

class ItemNameForEditItem: UIView {
    
    weak var delegate: ItemNameForEditItemDelegate?
    
    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "ITEM NAME:"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: TextFieldWithWarning = {
        let textField = TextFieldWithWarning(viewController)
        textField.placeholder = "Enter item name..."
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 17)
        textField.set(ValidationButtonRuleLeaf(message: "Please provide the Name for the Item") { $0 != "" })
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
        
        super.init(frame: CGRect.zero)

        self.setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface() {
        translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func isValid() -> Bool {
        return textField.isValid()
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}
