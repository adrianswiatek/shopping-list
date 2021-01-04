import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import UIKit

public final class CategoriesForEditItem: UIView {
    weak var delegate: CategoriesForEditItemDelegate?
    weak var viewController: UIViewController?
    
    public override var backgroundColor: UIColor? {
        get {
            super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
            pickerView.backgroundColor = newValue
        }
    }
    
    lazy var categories: [ItemsCategory] = fetchCategories()
    
    private func fetchCategories() -> [ItemsCategory] {
        // Todo: repository
        // var categories = Repository.shared.getCategories()
        var categories = [ItemsCategory]()
        let defaultCategory = ItemsCategory.default
        if categories.first(where: { $0.id == defaultCategory.id }) == nil {
            categories.append(defaultCategory)
        }
        
        return categories.sorted { $0.name < $1.name }
    }
    
    private lazy var label: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.text = "CATEGORY:"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    lazy var pickerView: UIPickerView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.dataSource = self
        $0.delegate = self
    }

    lazy var addButton: UIButton = configure(.init(type: .system)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        $0.addTarget(self, action: #selector(showAddCategoryPopup), for: .touchUpInside)
    }
    
    @objc func showAddCategoryPopup() {
        delegate?.categoriesForEditItemDidShowAddCategoryPopup(self)
        addCategoryPopup.show()
    }
    
    lazy var addCategoryPopup: AddCategoryPopupForEditItem = {
        guard let viewController = viewController else {
            fatalError("View Controller must have the value.")
        }
        
        return AddCategoryPopupForEditItem(viewController, { self.categories }, completed: categoryAdded)
    }()
    
    private func categoryAdded(withName name: String) {
        let category = ItemsCategory.withName(name)
        
        categories.append(category)

        // Todo: repository
        // Repository.shared.add(category)
        
        categories.sort { $0.name < $1.name }
        pickerView.reloadComponent(0)
        
        selectByName(name)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: EditItemViewController.labelsLeftPadding),
            label.widthAnchor.constraint(equalToConstant: EditItemViewController.labelsWidth),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func selectDefault() {
        selectByName(ItemsCategory.default.name)
    }
    
    func selectCategory(by name: String) {
        selectByName(name)
    }

    func selected() -> ItemsCategory? {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedRow]
        return selectedCategory.isDefault ? nil : selectedCategory
    }
    
    private func selectByName(_ name: String) {
        guard let index = categories.firstIndex(where: { $0.name == name }) else {
            return
        }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
}

extension CategoriesForEditItem: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        24
    }

    public func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        let label = UILabel()
        label.text = categories[row].name
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }
}

extension CategoriesForEditItem: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
}
