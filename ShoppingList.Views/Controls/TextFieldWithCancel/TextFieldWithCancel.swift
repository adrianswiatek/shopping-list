import ShoppingList_Shared
import Combine
import UIKit

public final class TextFieldWithCancel: UIView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }
    
    public var font: UIFont? {
        get { textField.font }
        set { textField.font = newValue }
    }

    public var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    private lazy var textField: UITextField = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .textPrimary
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
        $0.delegate = self
    }
    
    private lazy var cancelButton: UIButton = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Cancel", for: UIControl.State.normal)
        $0.setTitleColor(#colorLiteral(red: 0, green: 0.4117647059, blue: 0.8509803922, alpha: 1), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.addAction(UIAction { [weak self] _ in
            self?.textField.text = ""
            self?.textField.resignFirstResponder()
            self?.validationButton.alpha = 0
        }, for: .touchUpInside)
    }

    private lazy var validationButton: UIButton = configure(.init(type: .system)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "Warning"), for: .normal)
        $0.alpha = 0
        $0.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.onActionSubject.send(.validationError(self.validationMessage()))
        }, for: .touchUpInside)
    }

    private var validationRule: ValidationButtonRule?

    private let onActionSubject: PassthroughSubject<Action, Never>
    
    private var cancelButtonAnimations: CancelButtonAnimations!
    private var validationButtonAnimations: ValidationButtonAnimations!
    private var bottomShadowAnimations: BottomShadowAnimations!

    public override init(frame: CGRect) {
        self.onActionSubject = .init()

        super.init(frame: frame)

        self.cancelButtonAnimations = .init(cancelButton, self)
        self.validationButtonAnimations = .init(validationButton, textField, self)
        self.bottomShadowAnimations = .init(self)

        self.setupView()
        self.setupNormalShadow()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return true
    }
    
    private func setupView() {
        backgroundColor = .background
        
        addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        let cancelButtonTrailingConstraint = cancelButton.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: 48
        )
        cancelButtonTrailingConstraint.identifier = "CancelButtonTrailingConstraint"
        cancelButtonTrailingConstraint.isActive = true
        
        addSubview(validationButton)
        NSLayoutConstraint.activate([
            validationButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            validationButton.trailingAnchor.constraint(
                equalTo: cancelButton.leadingAnchor,
                constant: -8
            ),
            validationButton.heightAnchor.constraint(equalToConstant: 20),
            validationButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        let textFieldTrailingConstraint = textField.trailingAnchor.constraint(
            equalTo: cancelButton.leadingAnchor
        )
        textFieldTrailingConstraint.identifier = "TextFieldTrailingConstraint"
        textFieldTrailingConstraint.isActive = true

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNormalShadow() {
        bottomShadowAnimations.showNormalShadow()
    }
    
    private func setupEditingShadow() {
        bottomShadowAnimations.showEditShadow()
    }
}

extension TextFieldWithCancel: ButtonValidatable {
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
        textField.text.flatMap { validationRule?.validate(with: $0) }.map { $0.message } ?? ""
    }
}

extension TextFieldWithCancel: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        guard isValid() else { return false }

        onActionSubject.send(.confirm(text))
        
        textField.text = ""
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
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButtonAnimations.show()
        setupEditingShadow()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButtonAnimations.hide()
        validationButtonAnimations.hide()
        setupNormalShadow()
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        validationButtonAnimations.hide()
        return true
    }
}

extension TextFieldWithCancel {
    public enum Action {
        case change(_ text: String)
        case confirm(_ text: String)
        case validationError(_ text: String)
    }
}
