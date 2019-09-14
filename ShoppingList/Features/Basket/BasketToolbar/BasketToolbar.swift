import UIKit

final class BasketToolbar: UIView {
    var delegate: BasketToolbarDelegate?
    
    // MARK:- Regular toolbar
    
    private lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(editButtonHandler))
    }()
    
    @objc private func editButtonHandler() {
        delegate?.editButtonDidTap()
    }
    
    private lazy var actionButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonHandler))
    }()
    
    @objc private func actionButtonHandler() {
        delegate?.actionButtonDidTap()
    }
    
    private lazy var regularToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.setItems([
            editButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            actionButton,
            ], animated: true)
        toolbar.barTintColor = .white
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    // MARK:- Edit toolbar
    
    private lazy var deleteAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: #imageLiteral(resourceName: "Trash"),
            style: .plain,
            target: self,
            action: #selector(deleteAllButtonHandler))
        button.isEnabled = false
        return button
    }()
    
    @objc private func deleteAllButtonHandler() {
        delegate?.deleteAllButtonDidTap()
    }
    
    private lazy var restoreAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: #imageLiteral(resourceName: "RemoveFromBasket"),
            style: .plain,
            target: self,
            action: #selector(restoreAllButtonHandler))
        button.isEnabled = false
        return button
    }()
    
    @objc private func restoreAllButtonHandler() {
        delegate?.restoreAllButtonDidTap()
    }
    
    private lazy var editToolbar: UIToolbar = {
        let fixedSpace = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil)
        fixedSpace.width = 16
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonHandler))
        cancelButton.style = .done
        
        let toolbar = UIToolbar()
        toolbar.setItems([cancelButton, flexibleSpace, deleteAllButton, fixedSpace, restoreAllButton], animated: true)
        toolbar.alpha = 0
        toolbar.barTintColor = .white
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    @objc private func cancelButtonHandler() {
        delegate?.cancelButtonDidTap()
    }
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK:- Initialize
    
    init(viewController: UIViewController) {
        super.init(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: 50))
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        addSubview(regularToolbar)
        regularToolbar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        regularToolbar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        regularToolbar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        regularToolbar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(editToolbar)
        editToolbar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        editToolbar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        editToolbar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        editToolbar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(topLineView)
        topLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- API
    
    func setRegularMode() {
        regularToolbar.alpha = 1
        editToolbar.alpha = 0
        deleteAllButton.isEnabled = false
        restoreAllButton.isEnabled = false
    }
    
    func setEditMode() {
        regularToolbar.alpha = 0
        editToolbar.alpha = 1
        deleteAllButton.isEnabled = false
        restoreAllButton.isEnabled = false
    }
    
    func setButtonsAs(enabled: Bool) {
        let isInRegularMode = regularToolbar.alpha == 1
        if isInRegularMode {
            editButton.isEnabled = enabled
            actionButton.isEnabled = enabled
        } else {
            deleteAllButton.isEnabled = enabled
            restoreAllButton.isEnabled = enabled
        }
    }
}
