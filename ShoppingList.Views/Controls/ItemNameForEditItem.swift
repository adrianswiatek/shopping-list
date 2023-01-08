import ShoppingList_Shared
import Combine
import UIKit

public final class ItemNameForEditItem: UIView {
    public var onAction: AnyPublisher<Action, Never> {
        textField.onAction
            .compactMap { action -> Action? in
                guard case .showValidationPopup(let alertController) = action else {
                    return nil
                }
                return .showViewController(alertController)
            }
            .eraseToAnyPublisher()
    }

    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    private let label: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.text = "ITEM NAME:"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let textField: TextFieldWithWarning = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Enter item name..."
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 17)
        $0.set(ValidationButtonRuleLeaf.notEmptyItemRule)
    }

    private var cancellables: Set<AnyCancellable>

    public init() {
        self.cancellables = []

        super.init(frame: .zero)

        self.setupView()
        self.bind()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
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

    private func bind() {

    }
}

extension ItemNameForEditItem {
    public enum Action {
        case showViewController(_ viewController: UIViewController)
    }
}
