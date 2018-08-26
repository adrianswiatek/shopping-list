import UIKit

class ListsForEditItem: UIView {
    
    var delegate: ListsForEditItemDelegate?
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
    
    lazy var lists: [List] = {
        return Repository.shared.getLists().sorted { $0.name < $1.name }
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "LIST:"
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
        button.addTarget(self, action: #selector(showAddListPopup), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func showAddListPopup() {
        delegate?.listsForEditItemDidShowAddCategoryPopup(self)
        addListPopup.show()
    }
    
    lazy var addListPopup: AddListPopupForEditItem = {
        guard let viewController = viewController else {
            fatalError("View Controller must have the value.")
        }

        return AddListPopupForEditItem(viewController, completed: listAdded)
    }()
    
    private func listAdded(withName name: String) {
        let newName = ListNameGenerator().generate(from: name, and: lists)
        let list = List.new(name: newName)
        
        lists.append(list)
        
        Repository.shared.add(list)
        
        lists.sort { $0.name < $1.name }
        pickerView.reloadComponent(0)
        
        selectBy(name: newName)
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

    func select(by item: Item) {
        selectBy(name: item.list.name)
    }
    
    func selectBy(name: String) {
        guard let index = lists.index(where: { $0.name == name }) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    func getSelected() -> List {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        return lists[selectedRow]
    }
}
