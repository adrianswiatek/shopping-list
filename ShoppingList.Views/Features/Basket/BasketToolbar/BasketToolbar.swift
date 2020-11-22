import ShoppingList_Shared
import UIKit

public final class BasketToolbar: UIView {
    public var delegate: BasketToolbarDelegate?
    
    // MARK: - Regular toolbar
    
    private lazy var editButton: UIBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(editButtonHandler))
    
    private lazy var actionButton: UIBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonHandler))
    
    private lazy var regularToolbar: UIToolbar = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setItems([
            editButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            actionButton,
        ], animated: true)
        $0.barTintColor = .background
        $0.isTranslucent = false
    }
    
    // MARK: - Edit toolbar
    
    private lazy var deleteAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: #imageLiteral(resourceName: "Trash"),
            style: .plain,
            target: self,
            action: #selector(deleteAllButtonHandler))
        button.isEnabled = false
        return button
    }()

    private lazy var restoreAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: #imageLiteral(resourceName: "RemoveFromBasket"),
            style: .plain,
            target: self,
            action: #selector(restoreAllButtonHandler)
        )
        button.isEnabled = false
        return button
    }()
    
    private lazy var editToolbar: UIToolbar = {
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 16
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonHandler)
        )
        cancelButton.style = .done
        
        return configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setItems([cancelButton, flexibleSpace, deleteAllButton, fixedSpace, restoreAllButton], animated: true)
            $0.alpha = 0
            $0.barTintColor = .background
            $0.isTranslucent = false
        }
    }()

    private let topLineView: UIView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .line
    }

    public init(viewController: UIViewController) {
        super.init(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: 50))
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }

    public func setRegularMode() {
        regularToolbar.alpha = 1
        editToolbar.alpha = 0
        deleteAllButton.isEnabled = false
        restoreAllButton.isEnabled = false
    }

    public func setEditMode() {
        regularToolbar.alpha = 0
        editToolbar.alpha = 1
        deleteAllButton.isEnabled = false
        restoreAllButton.isEnabled = false
    }

    public func setButtonsAs(enabled: Bool) {
        let isInRegularMode = regularToolbar.alpha == 1
        if isInRegularMode {
            editButton.isEnabled = enabled
            actionButton.isEnabled = enabled
        } else {
            deleteAllButton.isEnabled = enabled
            restoreAllButton.isEnabled = enabled
        }
    }

    private func setupView() {
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

    @objc
    private func editButtonHandler() {
        delegate?.editButtonDidTap()
    }

    @objc
    private func actionButtonHandler() {
        delegate?.actionButtonDidTap()
    }

    @objc
    private func cancelButtonHandler() {
        delegate?.cancelButtonDidTap()
    }

    @objc
    private func deleteAllButtonHandler() {
        delegate?.deleteAllButtonDidTap()
    }

    @objc
    private func restoreAllButtonHandler() {
        delegate?.restoreAllButtonDidTap()
    }
}
