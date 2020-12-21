import ShoppingList_Shared
import UIKit

public final class ItemNameForEditItem: UIView {
    weak var delegate: ItemNameForEditItemDelegate?
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    lazy var label: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.text = "ITEM NAME:"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    lazy var textField: TextFieldWithWarning = configure(TextFieldWithWarning(viewController)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Enter item name..."
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 17)
        $0.set(ValidationButtonRuleLeaf.notEmptyItemRule)
    }
    
    private let viewController: UIViewController
    
    public init(_ viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: CGRect.zero)
        self.setupUserInterface()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: EditItemViewController.labelsLeftPadding),
            label.widthAnchor.constraint(equalToConstant: EditItemViewController.labelsWidth),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            textField.topAnchor.constraint(equalTo: label.topAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func isValid() -> Bool {
        textField.isValid()
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
