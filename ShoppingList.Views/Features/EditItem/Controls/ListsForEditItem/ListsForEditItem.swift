import ShoppingList_Domain
import ShoppingList_Shared
import UIKit

public final class ListsForEditItem: UIView {
    weak var delegate: ListsForEditItemDelegate?
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
    
    lazy var lists: [List] = {
        []
        // Todo: repository
        // Repository.shared.getLists().sorted { $0.name < $1.name }
    }()

    private let label: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.text = "LIST:"
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
        $0.addTarget(self, action: #selector(showAddListPopup), for: .touchUpInside)
    }

    lazy var addListPopup: AddListPopupForEditItem = {
        guard let viewController = viewController else {
            fatalError("View Controller must have the value.")
        }

        return AddListPopupForEditItem(viewController, completed: listAdded)
    }()
    
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
        guard let index = lists.firstIndex(where: { $0.name == name }) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    func getSelected() -> List {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        return lists[selectedRow]
    }

    @objc
    func showAddListPopup() {
        delegate?.listsForEditItemDidShowAddCategoryPopup(self)
        addListPopup.show()
    }

    private func listAdded(withName name: String) {
        let newName = ListNameGenerator.generate(from: name, and: lists)
        let list = List.withName(newName)

        lists.append(list)

        // Todo: repository
        // Repository.shared.add(list)

        lists.sort { $0.name < $1.name }
        pickerView.reloadComponent(0)

        selectBy(name: newName)
    }
}

extension ListsForEditItem: UIPickerViewDelegate {
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
        label.text = lists[row].name
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }
}

extension ListsForEditItem: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lists.count
    }
}
