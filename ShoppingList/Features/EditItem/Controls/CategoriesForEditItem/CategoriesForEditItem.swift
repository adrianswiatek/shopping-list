import UIKit

class CategoriesForEditItem: UIView {

    var delegate: CategoriesForEditItemDelegate?
    var viewController: UIViewController?
    
    override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
            pickerView.backgroundColor = newValue
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
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "CATEGORY:"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        button.addTarget(self, action: #selector(showAddCategoryTextField), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func showAddCategoryTextField() {
        delegate?.categoriesForEditItemDidShowAddCategoryPopup(self)
        addCategoryPopup.show()
    }
    
    lazy var addCategoryPopup: AddCategoryPopupForEditItem = {
        guard let viewController = viewController else {
            fatalError("View Controller must have the value.")
        }
        
        return AddCategoryPopupForEditItem(
            viewController: viewController,
            completed: categoryAdded)
    }()
    
    private func categoryAdded(withName name: String) {
        let category = Category.new(name: name)
        
        categories.append(category)
        
        Repository.shared.add(category)
        
        categories.sort { $0.name < $1.name }
        pickerView.reloadComponent(0)
        
        selectBy(name: name)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface() {
        backgroundColor = .white
        
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: EditItemViewController.labelsLeftPadding).isActive = true
        label.widthAnchor.constraint(equalToConstant: EditItemViewController.labelsWidth).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(addButton)
        addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        addButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(pickerView)
        pickerView.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func selectDefault() {
        selectBy(name: Category.getDefault().name)
    }
    
    func select(by item: Item) {
        selectBy(name: item.getCategoryName())
    }
    
    private func selectBy(name: String) {
        guard let index = categories.index(where: { $0.name == name }) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    func getSelected() -> Category? {
        let selectedCategoryRow = pickerView.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedCategoryRow]
        return selectedCategory.isDefault() ? nil : selectedCategory
    }
}
