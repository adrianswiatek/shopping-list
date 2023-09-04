import ShoppingList_Shared
import Combine
import UIKit

public final class ItemsToolbar: UIView {
    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Regular toolbar
    
    private lazy var editButton: UIBarButtonItem =
        .init(systemItem: .edit, primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.edit)
        })
    
    private lazy var addButton: UIBarButtonItem =
        .init(systemItem: .add, primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.add)
        })

    private lazy var searchButton: UIBarButtonItem =
        .init(systemItem: .search, primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.search)
        })
    
    private lazy var actionButton: UIBarButtonItem =
        .init(image: UIImage(systemName: "ellipsis.circle"), primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.action)
        })
    
    private lazy var regularToolbar: UIToolbar = configure(.init(frame: Metrics.toolbarsFrame)) {
        let items = [
            editButton, .flexibleSpace(), addButton, .fixedSpace(32) , searchButton, .flexibleSpace(), actionButton
        ]

        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setItems(items, animated: true)
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

    private lazy var addToBasketButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "AddToBasket"), primaryAction: .init { [weak self] _ in
            self?.onActionSubject.send(.moveToList)
        })
        button.isEnabled = false
        return button
    }()

    private lazy var editToolbar: UIToolbar = {
        let cancelButton = UIBarButtonItem(
            systemItem: .cancel,
            primaryAction: .init { [weak self] _ in self?.onActionSubject.send(.cancel) }
        )
        cancelButton.style = .done
        
        return configure(.init(frame: Metrics.toolbarsFrame)) {
            let items = [
                cancelButton, .flexibleSpace(), removeButton, .fixedSpace(16), addToBasketButton
            ]

            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setItems(items, animated: true)
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
        addToBasketButton.isEnabled = false
    }

    public func setEditMode() {
        regularToolbar.alpha = 0
        editToolbar.alpha = 1
        removeButton.isEnabled = false
        addToBasketButton.isEnabled = false
    }

    public func setButtonsAs(enabled: Bool) {
        let isInRegularMode = regularToolbar.alpha == 1
        if isInRegularMode {
            editButton.isEnabled = enabled
            actionButton.isEnabled = enabled
        } else {
            removeButton.isEnabled = enabled
            addToBasketButton.isEnabled = enabled
        }
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

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
            topLineView.heightAnchor.constraint(equalToConstant: 0.5),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

public extension ItemsToolbar {
    enum Action {
        case action
        case add
        case cancel
        case edit
        case moveToList
        case remove
        case search
    }
}

private extension ItemsToolbar {
    enum Metrics {
        static let toolbarsFrame: CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    }
}
