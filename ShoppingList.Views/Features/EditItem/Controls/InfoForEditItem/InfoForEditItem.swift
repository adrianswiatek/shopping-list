import ShoppingList_Shared
import UIKit

public final class InfoForEditItem: UIView {
    weak var delegate: InfoForEditItemDelegate?
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    lazy var label: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.text = "INFO:"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    lazy var textField: UITextField = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Enter additional info..."
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 17)
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        $0.leftViewMode = .always
        $0.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
    private func setupView() {
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

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
}

extension InfoForEditItem: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.descriptionDidBeginEditing(self)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
