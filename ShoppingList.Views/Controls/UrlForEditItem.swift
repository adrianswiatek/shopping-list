import ShoppingList_Shared
import UIKit

public final class UrlForEditItem: UIView {
    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    public let label: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.text = "URL:"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    public lazy var textField: TextFieldWithWarning = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.autocapitalizationType = .none
        $0.placeholder = "Enter url..."
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 17)
        $0.textContentType = .URL
        $0.set(ValidationButtonRuleLeaf.validUrlOrEmptyRule)
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: EditItemViewController.labelsLeftPadding
            ),
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

    public func isValid() -> Bool {
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

extension UrlForEditItem: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
