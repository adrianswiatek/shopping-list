import UIKit

class EditItemViewController: UIViewController {
    
    static let labelsWidth: CGFloat = 100
    static let labelsLeftPadding: CGFloat = 16
    
    var delegate: EditItemViewControllerDelegate!
    
    var list: List!  {
        didSet {
            guard let list = list else { return }
            listsView.selectBy(name: list.name)
        }
    }
    
    var item: Item? {
        didSet {
            guard let item = item else {
                itemNameView.becomeFirstResponder()
                categoriesView.selectDefault()
                listsView.isHidden = true
                return
            }
            
            itemNameView.text = item.name
            categoriesView.select(by: item)
        }
    }

    lazy var itemNameView: ItemNameForEditItem = {
        let itemName = ItemNameForEditItem()
        itemName.translatesAutoresizingMaskIntoConstraints = false
        return itemName
    }()
    
    lazy var infoView: InfoForEditItem = {
        let info = InfoForEditItem()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    lazy var categoriesView: CategoriesForEditItem = {
        let categories = CategoriesForEditItem()
        categories.delegate = self
        categories.viewController = self
        categories.translatesAutoresizingMaskIntoConstraints = false
        return categories
    }()
    
    lazy var listsView: ListsForEditItem = {
        let lists = ListsForEditItem()
        lists.delegate = self
        lists.viewController = self
        lists.translatesAutoresizingMaskIntoConstraints = false
        return lists
    }()
    
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
        guard let itemName = itemNameView.text, itemName != "" else { return }
        
        let list = listsView.getSelected()
        let category = categoriesView.getSelected()
        var itemToSave: Item
        
        if let existingItem = self.item {
            itemToSave = Item(id: existingItem.id, name: itemName, description: "", state: existingItem.state, category: category, list: list)
        } else {
            itemToSave = Item.toBuy(name: itemName, description: "", list: list, category: category)
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
            
            self?.updatePreviousListIfHasChanged(newList: list)
        }
    }
    
    private func updatePreviousListIfHasChanged(newList: List) {
        let areListsTheSame = newList.id == list.id
        if !areListsTheSame, let previousList = Repository.shared.getList(by: list.id) {
            Repository.shared.update(previousList.getWithChangedDate())
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        validateStartingContract()
        setupUserInterface()
    }
    
    private func validateStartingContract() {
        guard delegate != nil, list != nil else {
            fatalError("Found nil in starting contract.")
        }
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
        
        view.addSubview(itemNameView)
        itemNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        itemNameView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        itemNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        itemNameView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(infoView)
        infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: itemNameView.bottomAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(categoriesView)
        categoriesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoriesView.topAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        categoriesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoriesView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(listsView)
        listsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listsView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor).isActive = true
        listsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listsView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        itemNameView.resignFirstResponder()
        infoView.resignFirstResponder()
    }
}
