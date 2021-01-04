import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import Combine
import UIKit

public final class EditItemViewController: UIViewController {
    internal static let labelsWidth: CGFloat = 100
    internal static let labelsLeftPadding: CGFloat = 16
    
    public var delegate: EditItemViewControllerDelegate!
    
    public var list: List! {
        didSet {
            guard let list = list else { return }
            listsView.selectBy(name: list.name)
        }
    }
    
    public var item: Item?

    private lazy var itemNameView: ItemNameForEditItem =
        configure(.init(self)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    
    private var infoView: InfoForEditItem =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    
    private lazy var categoriesView: CategoriesForEditItem =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
            $0.viewController = self
        }
    
    private lazy var listsView: ListsForEditItem =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
            $0.viewController = self
        }
    
    private lazy var cancelBarButtonItem: UIBarButtonItem =
        .init(systemItem: .cancel, primaryAction: .init { [weak self] _ in self?.dismiss(animated: true) })
    
    private lazy var saveBarButtonItem: UIBarButtonItem =
        .init(barButtonSystemItem: .save, target: self, action: #selector(save))
    
    @objc
    private func save() {
        guard let itemName = itemNameView.text else { return }
        guard itemNameView.isValid() else { return }
        
        let list = listsView.selected()
        let category = categoriesView.selected()
        let info = infoView.text ?? ""

        var itemToSave: Item
        
        if let existingItem = self.item {
            itemToSave = Item(
                id: existingItem.id,
                name: itemName,
                info: info,
                state: existingItem.state,
                category: category,
                list: list
            )
        } else {
            itemToSave = .toBuy(
                name: itemName,
                info: info,
                list: list,
                category: category
            )
        }

        dismiss(animated: true) { [weak self] in
            let itemIsBeingCreated = self?.item == nil
            if itemIsBeingCreated {
                self?.delegate?.didCreate(itemToSave)
                // Todo: repository
                // Repository.shared.add(itemToSave)
            } else if let previousItem = self?.item {
                self?.delegate?.didUpdate(previousItem, itemToSave)
                // Todo: repository
                // Repository.shared.update(itemToSave)
            }
            
            self?.updatePreviousListIfHasChanged(newList: list)
        }
    }
    
    private func updatePreviousListIfHasChanged(newList: List) {
        // Todo: repository
        // let areListsTheSame = newList.id == list.id
        // if !areListsTheSame, let previousList = Repository.shared.getList(by: list.id) {
            // Repository.shared.update(previousList.getWithChangedDate())
        // }
    }

    private let viewModel: EditItemViewModel
    private var cancellables: Set<AnyCancellable>

    public init(viewModel: EditItemViewModel) {
        self.viewModel = viewModel
        self.cancellables = []

        super.init(nibName: nil, bundle: nil)

        self.bind()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)
        view.isOpaque = false
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationItem.title = item != nil ? "Edit Item" : "Add Item"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
        ]
        
        view.addSubview(itemNameView)
        NSLayoutConstraint.activate([
            itemNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemNameView.topAnchor.constraint(equalTo: view.topAnchor),
            itemNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemNameView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        view.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.topAnchor.constraint(equalTo: itemNameView.bottomAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        view.addSubview(categoriesView)
        NSLayoutConstraint.activate([
            categoriesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesView.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            categoriesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(listsView)
        NSLayoutConstraint.activate([
            listsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listsView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor),
            listsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listsView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func bind() {
        viewModel.statePublisher
            .sink { [weak self] in
                switch $0 {
                case .create:
                    self?.itemNameView.becomeFirstResponder()
                    self?.categoriesView.selectDefault()
                    self?.listsView.isHidden = true
                case .edit(let item):
                    self?.itemNameView.text = item.name
                    self?.infoView.text = item.info
                    self?.categoriesView.selectCategory(by: item.categoryName)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        itemNameView.resignFirstResponder()
        infoView.resignFirstResponder()
    }
}

extension EditItemViewController: CategoriesForEditItemDelegate {
    public func categoriesForEditItemDidShowAddCategoryPopup(_ categoriesForEditItem: CategoriesForEditItem) {
        itemNameView.resignFirstResponder()
    }
}

extension EditItemViewController: ListsForEditItemDelegate {
    public func listsForEditItemDidShowAddCategoryPopup(_ categoriesForEditItem: ListsForEditItem) {
        itemNameView.resignFirstResponder()
    }
}

extension EditItemViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
