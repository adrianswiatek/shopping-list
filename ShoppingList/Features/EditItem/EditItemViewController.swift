import UIKit

class EditItemViewController: UIViewController {
    
    var delegate: EditItemViewControllerDelegate?
    
    var item: Item? {
        didSet {
            guard let item = item else {
                if let rowOfCategory = categories.index(where: { $0.name == Category.getDefault().name }) {
                    categoriesPickerView.selectRow(rowOfCategory, inComponent: 0, animated: true)
                }
                return
            }
            itemNameTextField.text = item.name
            
            if let rowOfCategory = categories.index(where: { $0.name == item.getCategoryName() }) {
                categoriesPickerView.selectRow(rowOfCategory, inComponent: 0, animated: true)
            }
        }
    }
    
    lazy var categories: [Category] = {
        return fetchCategories()
    }()
    
    private func fetchCategories() -> [Category] {
        var categories = Repository.shared.getCategories()
        
        let defaultCategory = Category.getDefault()
        if categories.first(where: { $0.id == defaultCategory.id }) == nil {
            categories.append(defaultCategory)
        }
        
        return categories.sorted { $0.name < $1.name }
    }
    
    // MARK: - Controls
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
    }()
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }()
    
    @objc private func save() {
        guard let itemName = itemNameTextField.text, itemName != "" else { return }
        
        let selectedCategoryRow = categoriesPickerView.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedCategoryRow]
        let category = selectedCategory.isDefault() ? nil : selectedCategory
        
        var itemToSave: Item
        
        if let existingItem = self.item {
            itemToSave = Item(id: existingItem.id, name: itemName, state: existingItem.state, category: category)
        } else {
            itemToSave = Item.toBuy(name: itemName, category: category)
        }

        dismiss(animated: true) { [weak self] in
            let itemIsBeingCreated = self?.item == nil
            if itemIsBeingCreated {
                self?.delegate?.didCreate(itemToSave)
                Repository.shared.add(itemToSave)
            } else if let previousItem = self?.item {
                self?.delegate?.didUpdate(previousItem, itemToSave)
                Repository.shared.update(itemToSave)
            }
        }
    }
    
    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "ITEM NAME:"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var itemNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Item Name..."
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 17)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "CATEGORY:"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var categoriesPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        button.addTarget(self, action: #selector(showAddCategoryTextField), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func showAddCategoryTextField() {
        addCategoryTextFieldAnimations.show()
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addCategoryTextField: TextFieldWithCancel = {
        let textFieldWithCancel = TextFieldWithCancel(viewController: self, placeHolder: "Enter new category name")
        textFieldWithCancel.font = .systemFont(ofSize: 17)
        textFieldWithCancel.backgroundColor = .white
        textFieldWithCancel.delegate = self
        textFieldWithCancel.translatesAutoresizingMaskIntoConstraints = false
        return textFieldWithCancel
    }()

    lazy var addCategoryTextFieldAnimations: AddCategoryTextFieldAnimations = {
        return AddCategoryTextFieldAnimations(self, addCategoryTextField, addCategoryButton)
    }()
    
    // MARK: - Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    private func setupUserInterface() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)
        view.isOpaque = false
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationItem.title = item != nil ? "Edit Item" : "Add Item"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
        ]

        containerView.addSubview(itemNameLabel)
        itemNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        itemNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24).isActive = true
        itemNameLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        itemNameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        containerView.addSubview(itemNameTextField)
        itemNameTextField.leadingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor, constant: 16).isActive = true
        itemNameTextField.topAnchor.constraint(equalTo: itemNameLabel.topAnchor).isActive = true
        itemNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        itemNameTextField.heightAnchor.constraint(equalTo: itemNameLabel.heightAnchor).isActive = true
        
        containerView.addSubview(categoriesPickerView)
        categoriesPickerView.leadingAnchor.constraint(equalTo: itemNameTextField.leadingAnchor).isActive = true
        categoriesPickerView.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor).isActive = true
        categoriesPickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -56).isActive = true
        categoriesPickerView.heightAnchor.constraint(equalToConstant: 115).isActive = true
        
        containerView.addSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: categoriesPickerView.centerYAnchor).isActive = true
        categoryLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        containerView.addSubview(addCategoryButton)
        addCategoryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        addCategoryButton.centerYAnchor.constraint(equalTo: categoriesPickerView.centerYAnchor).isActive = true
        
        view.addSubview(addCategoryTextField)
        addCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addCategoryTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        let addCategoryTextFieldTopConstraint = NSLayoutConstraint(
            item: addCategoryTextField,
            attribute: .top,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .bottom,
            multiplier: 1,
            constant: -50)
        
        addCategoryTextFieldTopConstraint.identifier = "AddCategoryTextFieldTopConstraint"
        addCategoryTextFieldTopConstraint.isActive = true
    }
}
