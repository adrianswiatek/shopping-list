import ShoppingList_Shared
import Combine
import UIKit

public final class BasketToolbar: UIView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    // MARK: - Regular toolbar
    
    private lazy var editButton: UIBarButtonItem =
        .init(systemItem: .edit, primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.edit)
        })
    
    private lazy var actionButton: UIBarButtonItem =
        .init(systemItem: .action, primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.action)
        })
    
    private lazy var regularToolbar: UIToolbar = configure(.init(frame: Metrics.toolbarsFrame)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setItems([
            editButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            actionButton
        ], animated: true)
        $0.barTintColor = .background
        $0.isTranslucent = false
    }
    
    // MARK: - Edit toolbar
    
    private lazy var removeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Trash"), primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.remove)
        })
        button.isEnabled = false
        return button
    }()

    private lazy var moveToListButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "RemoveFromBasket"), primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.moveToList)
        })
        button.isEnabled = false
        return button
    }()
    
    private lazy var editToolbar: UIToolbar = {
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 16
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let cancelButton = UIBarButtonItem(
            systemItem: .cancel,
            primaryAction: .init { [weak self] _ in self?.onActionSubject.send(.cancel) }
        )
        cancelButton.style = .done
        
        return configure(.init(frame: Metrics.toolbarsFrame)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setItems([
                cancelButton,
                flexibleSpace,
                removeButton,
                fixedSpace,
                moveToListButton
            ], animated: true)
            $0.alpha = 0
            $0.barTintColor = .background
            $0.isTranslucent = false
        }
    }()

    private let topLineView: UIView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .line
    }

    private let onActionSubject: PassthroughSubject<Action, Never>

    public init() {
        self.onActionSubject = .init()
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    public func setRegularMode() {
        regularToolbar.alpha = 1
        editToolbar.alpha = 0
        removeButton.isEnabled = false
        moveToListButton.isEnabled = false
    }

    public func setEditMode() {
        regularToolbar.alpha = 0
        editToolbar.alpha = 1
        removeButton.isEnabled = false
        moveToListButton.isEnabled = false
    }

    public func setButtonsAs(enabled: Bool) {
        let isInRegularMode = regularToolbar.alpha == 1
        if isInRegularMode {
            editButton.isEnabled = enabled
            actionButton.isEnabled = enabled
        } else {
            removeButton.isEnabled = enabled
            moveToListButton.isEnabled = enabled
        }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])

        addSubview(regularToolbar)
        NSLayoutConstraint.activate([
            regularToolbar.topAnchor.constraint(equalTo: topAnchor),
            regularToolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            regularToolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            regularToolbar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(editToolbar)
        NSLayoutConstraint.activate([
            editToolbar.topAnchor.constraint(equalTo: topAnchor),
            editToolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            editToolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            editToolbar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(topLineView)
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}

public extension BasketToolbar {
    enum Action {
        case action
        case cancel
        case edit
        case moveToList
        case remove
    }
}

private extension BasketToolbar {
    enum Metrics {
        static let toolbarsFrame: CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    }
}
