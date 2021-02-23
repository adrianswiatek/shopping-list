import ShoppingList_Shared
import Combine
import UIKit

public final class TextFieldWithWarning: UIView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

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

    private var validationButtonAnimations: ValidationButtonAnimations!
    private var validationRule: ValidationButtonRule?

    private let onActionSubject: PassthroughSubject<Action, Never>

    public init() {
        self.onActionSubject = .init()

        super.init(frame: .zero)

        self.validationButtonAnimations = .init(validationButton, textField, self)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    private func setupView() {
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

    @objc
    private func handleValidation() {
        let alertController = UIAlertController(title: "", message: validationMessage(), preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default) { [weak self] _ in
            self?.onActionSubject.send(.validationPopupDidHide)
            self?.textField.becomeFirstResponder()
        })

        onActionSubject.send(.showValidationPopup(alertController))
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

    public func validationMessage() -> String {
        textField.text.flatMap { validationRule?.validate(with: $0).message } ?? ""
    }
}

extension TextFieldWithWarning: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text != nil, isValid() else {
            return false
        }

        onActionSubject.send(.didFinishEditing)
        textField.resignFirstResponder()

        return true
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
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

extension TextFieldWithWarning {
    public enum Action {
        case didFinishEditing
        case showValidationPopup(_ alertController: UIAlertController)
        case validationPopupDidHide
    }
}
