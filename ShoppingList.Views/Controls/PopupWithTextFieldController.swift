import ShoppingList_Shared
import UIKit

public final class PopupWithTextFieldController: UIViewController {
    public var popupTitle: String? {
        didSet {
            titleLabel.text = popupTitle
        }
    }
    
    public var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    public var text: String? {
        didSet {
            textField.text = text
        }
    }
    
    public var saved: ((String) -> Void)?
    public var cancelled: (() -> Void)?
    
    private lazy var popupView: UIView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(white: 1, alpha: 0.98)
        $0.layer.cornerRadius = 16
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOpacity = 1
        $0.clipsToBounds = true
    }
    
    private let titleLabel: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "The Title"
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = UIColor(white: 0, alpha: 0.7)
    }
    
    private lazy var saveButton: UIButton = configure(ButtonWithHighlight(type: .custom)) {
        $0.setTitle("Save", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitleColor(colorForHighlightedButton, for: .normal)
        $0.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
    }
    
    private lazy var cancelButton: UIButton = configure(ButtonWithHighlight(type: .custom)) {
        $0.setTitle("Cancel", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(colorForHighlightedButton, for: .normal)
        $0.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
    }
    
    private lazy var textField: TextFieldWithWarning = {
        let textField = TextFieldWithWarning(self)
        textField.backgroundColor = .white
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 15)
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor(white: 0.75, alpha: 1).cgColor
        textField.layer.borderWidth = 0.25
        textField.becomeFirstResponder()
        textField.validationPopupWillAppear = { [weak self] in
            self?.popupView.alpha = 0
        }
        textField.validationPopupWillDisappear = { [weak self] in
            UIView.animate(withDuration: 0.2) { self?.popupView.alpha = 1 }
        }
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let headerView: UIView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let contentView: UIView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let footerView: UIView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let popupViewHeight: CGFloat = 180
    private var popupViewCenterYConstraint: NSLayoutConstraint!

    private var colorForHighlightedButton: UIColor {
        UIColor(red: 84 / 255, green: 152 / 255, blue: 252 / 255, alpha: 1)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = .crossDissolve
        
        self.setupKeyboardEventsObservers()
        self.setupUserInterface()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func set(_ validationRules: ValidationButtonRule) {
        textField.set(validationRules)
    }
    
    private func setupKeyboardEventsObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWilldHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if popupView.bounds == .zero {
                popupViewCenterYConstraint.constant = -keyboardFrame.height / 2
            } else {
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                    self.popupViewCenterYConstraint.constant = -keyboardFrame.height / 2
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc
    private func keyboardWilldHide(_ notification: Notification) {
        guard popupViewCenterYConstraint.constant != 0 else { return }
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.popupViewCenterYConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupUserInterface() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        view.addSubview(popupView)
        popupViewCenterYConstraint = popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        popupViewCenterYConstraint.isActive = true
        
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48).isActive = true
        popupView.heightAnchor.constraint(equalToConstant: popupViewHeight).isActive = true
        
        setupHeader()
        setupFooter()
        setupContent()
    }
    
    private func setupHeader() {
        popupView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: popupView.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
    
    private func setupFooter() {
        popupView.addSubview(footerView)
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: footerView.topAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
        
        let dividerViewColor = UIColor(white: 0, alpha: 0.1)
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = dividerViewColor
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(topDividerView)
        NSLayoutConstraint.activate([
            topDividerView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            topDividerView.topAnchor.constraint(equalTo: footerView.topAnchor),
            topDividerView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        let cancelDividerView = UIView()
        cancelDividerView.backgroundColor = dividerViewColor
        cancelDividerView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addSubview(cancelDividerView)
        NSLayoutConstraint.activate([
            cancelDividerView.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            cancelDividerView.trailingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            cancelDividerView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            cancelDividerView.widthAnchor.constraint(equalToConstant: 0.25)
        ])
        
        let saveDividerView = UIView()
        saveDividerView.backgroundColor = dividerViewColor
        saveDividerView.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.addSubview(saveDividerView)
        NSLayoutConstraint.activate([
            saveDividerView.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
            saveDividerView.topAnchor.constraint(equalTo: saveButton.topAnchor),
            saveDividerView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor),
            saveDividerView.widthAnchor.constraint(equalToConstant: 0.25)
        ])
    }
    
    private func setupContent() {
        popupView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
        
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    @objc
    private func handleSaveButton() {
        guard textField.isValid() else { return }
        saved?(textField.text ?? "")
        dismiss(animated: true)
    }

    @objc
    private func handleCancelButton() {
        cancelled?()
        dismiss(animated: true)
    }
}

extension PopupWithTextFieldController: TextFieldWithWarningDelegate {
    public func textFieldWithWarning(
        _ textFieldWithWarning: TextFieldWithWarning,
        didReturnWith text: String
    ) {
        handleSaveButton()
    }
}
