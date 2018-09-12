import UIKit

class PopupWithTextFieldController: UIViewController {

    var popupTitle: String? {
        didSet {
            titleLabel.text = popupTitle
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var text: String? {
        didSet {
            textField.text = text
        }
    }
    
    var saved: ((String) -> Void)?
    var cancelled: (() -> Void)?
    
    private lazy var popupView: UIView = { [unowned self] in
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.98)
        view.layer.cornerRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Title"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = UIColor(white: 0, alpha: 0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = ButtonWithHighlight(type: .custom)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(colorForHighlightedButton, for: .normal)
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleSaveButton() {
        if textField.isValid() {
            saved?(textField.text ?? "")
            dismiss(animated: true)
        }
    }
    
    private lazy var cancelButton: UIButton = {
        let button = ButtonWithHighlight(type: .custom)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(colorForHighlightedButton, for: .normal)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleCancelButton() {
        cancelled?()
        dismiss(animated: true)
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let popupViewHeight: CGFloat = 180
    private var popupViewCenterYConstraint: NSLayoutConstraint!
    private var colorForHighlightedButton: UIColor {
        return UIColor(red: 84 / 255, green: 152 / 255, blue: 252 / 255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalTransitionStyle = .crossDissolve
        
        setupKeyboardEventsObservers()
        setupUserInterface()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
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
    
    @objc private func keyboardWilldHide(_ notification: Notification) {
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
        headerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        headerView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    }
    
    private func setupFooter() {
        popupView.addSubview(footerView)
        footerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(buttonsStackView)
        buttonsStackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor).isActive = true
        buttonsStackView.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
        
        let dividerViewColor = UIColor(white: 0, alpha: 0.1)
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = dividerViewColor
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(topDividerView)
        topDividerView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor).isActive = true
        topDividerView.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        topDividerView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor).isActive = true
        topDividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let cancelDividerView = UIView()
        cancelDividerView.backgroundColor = dividerViewColor
        cancelDividerView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addSubview(cancelDividerView)
        cancelDividerView.topAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        cancelDividerView.trailingAnchor.constraint(equalTo: cancelButton.trailingAnchor).isActive = true
        cancelDividerView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor).isActive = true
        cancelDividerView.widthAnchor.constraint(equalToConstant: 0.25).isActive = true
        
        let saveDividerView = UIView()
        saveDividerView.backgroundColor = dividerViewColor
        saveDividerView.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.addSubview(saveDividerView)
        saveDividerView.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor).isActive = true
        saveDividerView.topAnchor.constraint(equalTo: saveButton.topAnchor).isActive = true
        saveDividerView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor).isActive = true
        saveDividerView.widthAnchor.constraint(equalToConstant: 0.25).isActive = true
    }
    
    private func setupContent() {
        popupView.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        
        contentView.addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
}

extension PopupWithTextFieldController: TextFieldWithWarningDelegate {
    func textFieldWithWarning(_ textFieldWithWarning: TextFieldWithWarning, didReturnWith text: String) {
        handleSaveButton()
    }
}
