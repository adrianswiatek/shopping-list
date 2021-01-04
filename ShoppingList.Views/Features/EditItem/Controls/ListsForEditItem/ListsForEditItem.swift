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
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: EditItemViewController.labelsLeftPadding
            ),
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
            pickerView.trailingAnchor.constraint(
                equalTo: addButton.leadingAnchor,
                constant: -8
            ),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func select(by item: Item) {
        selectBy(name: item.list.name)
    }
    
    func selectBy(name: String) {
        guard let index = lists.firstIndex(where: { $0.name == name }) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    func selected() -> List {
        lists[pickerView.selectedRow(inComponent: 0)]
    }

    @objc
    func showAddListPopup() {
        delegate?.listsForEditItemDidShowAddCategoryPopup(self)
        addListPopup.show()
    }

    private func listAdded(withName name: String) {
        // TODO: ListNameGenerator
        // let newName = ListNameGenerator.generate(from: name, and: lists)
        let newName = "TODO: ListNameGenerator"
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
    public func pickerView(
        _ pickerView: UIPickerView,
        rowHeightForComponent component: Int
    ) -> CGFloat {
        24
    }

    public func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        configure(UILabel()) {
            $0.text = lists[row].name
            $0.font = .systemFont(ofSize: 18)
            $0.textAlignment = .center
        }
    }
}

extension ListsForEditItem: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        lists.count
    }
}
