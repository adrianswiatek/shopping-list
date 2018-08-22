import UIKit

// TODO: Add blur effect to the popup.

class PopupWithTextFieldController: UIViewController {

    var popupTitle: String? {
        didSet {
            titleLabel.text = popupTitle
        }
    }
    
    var saved: ((String) -> Void)?
    var cancelled: (() -> Void)?
    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.9
        view.layer.cornerRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Title"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = UIColor(white: 0, alpha: 0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        button.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    @objc private func handleSaveButton() {
        cancelled?()
        dismiss(animated: true)
    }
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        button.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    @objc private func handleCancelButton() {
        cancelled?()
        dismiss(animated: true)
    }
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        setupHeader()
        setupFooter()
        setupContent()
        
        view.addSubview(popupView)
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48).isActive = true
        popupView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupHeader() {
        popupView.addSubview(headerView)
        headerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
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
    }
    
    private func setupContent() {
        popupView.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
    }
}
