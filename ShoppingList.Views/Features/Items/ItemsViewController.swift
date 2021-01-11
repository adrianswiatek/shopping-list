import ShoppingList_Domain
import ShoppingList_Shared
import ShoppingList_ViewModels
import UIKit

public protocol ItemsViewControllerDelegate: class {
    func goToBasket()
    func goToEditItem(_ item: ItemViewModel, for list: ListViewModel)
    func goToCreateItem(for list: ListViewModel)
    func didDismiss()
}

public final class ItemsViewController: UIViewController {
    public weak var delegate: ItemsViewControllerDelegate?

    private let sharedItemsFormatter = SharedItemsFormatter()

    private var items = [[Item]]()
    private var categories = [ItemsCategory]()

    private let tableView: ItemsTableView
    
    private lazy var addItemTextField: TextFieldWithCancel =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.set(ValidationButtonRuleLeaf.notEmptyItemRule)
            $0.layer.zPosition = 1
            $0.placeholder = "Add new item..."
        }
    
    private lazy var toolbar: ItemsToolbar =
        configure(.init(viewController: self)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
        }

    private let bottomView: UIView =
        configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
        }
    
    private lazy var filledBasketBarButtonItem: UIBarButtonItem =
        UIBarButtonItem(image: #imageLiteral(resourceName: "Basket"), primaryAction: .init { [weak self] _ in
            self?.delegate?.goToBasket()
        })
    
    private lazy var emptyBasketBarButtonItem: UIBarButtonItem =
        UIBarButtonItem(image: #imageLiteral(resourceName: "EmptyBasket"), primaryAction: .init { [weak self] _ in
            self?.delegate?.goToBasket()
        })
    
    private lazy var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), primaryAction: .init { [weak self] _ in
            self?.viewModel.restoreItem()
        })
        barButtonItem.isEnabled = false
        return barButtonItem
    }()

    private let viewModel: ItemsViewModel

    public init(viewModel: ItemsViewModel) {
        self.viewModel = viewModel
        self.tableView = .init()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUserInterface()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchItems()
        tableView.reloadData()
        
        refreshUserInterface()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            self.delegate?.didDismiss()
        }

        self.viewModel.cleanUp()
    }
    
    public func fetchItems() {
        // Todo: repository
        // let allItems = Repository.shared.getItemsWith(state: .toBuy, in: currentList)
//        let allItems: [Item] = []
//        var items = [[Item]]()
//        self.categories = Set(allItems.map { $0.category }).sorted { $0.name < $1.name }
        
//        for category in categories {
//            let itemsInCategory = allItems.filter { $0.categoryName() == category.name }
//            items.append(itemsInCategory)
//        }
        
//        self.items = items
    }
    
    private func setupUserInterface() {
        navigationItem.title = viewModel.list.name

        view.addSubview(addItemTextField)
        NSLayoutConstraint.activate([
            addItemTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addItemTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addItemTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addItemTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addItemTextField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func refreshUserInterface(after: Double = 0) {
        setTopBarButtons()
        
        items.count > 0 ? setSceneAsEditable() : setSceneAsNotEditable()
        tableView.setEditing(false, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
            self?.clearCategoriesIfNeeded()
        }
    }
    
    private func setTopBarButtons() {
        restoreBarButtonItem.isEnabled = viewModel.isRestoreButtonEnabled
        navigationItem.rightBarButtonItems = [
            viewModel.hasItemsInBasket() ? filledBasketBarButtonItem : emptyBasketBarButtonItem,
            restoreBarButtonItem
        ]
    }
    
    private func setSceneAsEditable() {
        toolbar.setRegularMode()
        toolbar.setButtonsAs(enabled: true)
        tableView.backgroundView = nil
    }
    
    private func setSceneAsNotEditable() {
        toolbar.setRegularMode()
        toolbar.setButtonsAs(enabled: false)
        tableView.setTextIfEmpty("Your shopping list is empty")
    }
    
    private func clearCategoriesIfNeeded() {
        if items.count == 0 {
            let range = 0 ..< categories.count
            categories.removeAll()
            tableView.deleteSections(IndexSet(range), with: .middle)
        } else {
            for (index, itemsInCategory) in items.enumerated().sorted(by: { $0.offset > $1.offset }) {
                if itemsInCategory.count == 0 {
                    items.remove(at: index)
                    categories.remove(at: index)
                    tableView.deleteSections(IndexSet(integer: index), with: .middle)
                }
            }
        }
    }
    
    private func append(_ category: ItemsCategory) {
        categories.append(category)
        categories.sort { $0.name < $1.name }
        
        let categoryIndex = getIndexOfCategory(with: category.id)
        items.insert([Item](), at: categoryIndex)
        tableView.insertSections(IndexSet(integer: categoryIndex), with: .automatic)
    }
    
    private func getCategoryIndex(_ item: Item) -> Int {
        getIndexOfCategory(with: item.categoryId)
    }
    
    private func getIndexOfCategory(with id: Id<ItemsCategory>) -> Int {
        guard let index =  categories.firstIndex (where: { $0.id == id }) else {
            fatalError("Unable to find category index.")
        }
        
        return index
    }
}

extension ItemsViewController: EditItemViewControllerDelegate {
    public func didCreate(_ item: Item) {
        didSave(item) {
            let categoryIndex = getCategoryIndex(item)
            items[categoryIndex].insert(item, at: 0)

            let indexPath = IndexPath(row: 0, section: categoryIndex)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    public func didUpdate(_ previousItem: Item, _ newItem: Item) {
        didSave(newItem) {
            let isBeingUpdatedInTheSameList = previousItem.listId == newItem.listId
            if !isBeingUpdatedInTheSameList {
                moveToOtherList(previousItem)
                return
            }

            let isBeingUpdatedInTheSameCategory = previousItem.categoryId == newItem.categoryId
            isBeingUpdatedInTheSameCategory
                ? updateItemInTheSameCategory(newItem)
                : updateItemInDifferentCategories(previousItem, newItem)
        }
    }

    private func moveToOtherList(_ item: Item) {
        guard
            let categoryIndex = categories.firstIndex(where: { $0.id == item.categoryId }),
            let itemIndex = items[categoryIndex].firstIndex(where: { $0.id == item.id })
        else { return }

        updatePreviousItem(at: itemIndex, and: categoryIndex)
        removeCategoryIfEmpty(at: categoryIndex)

        // Todo: repository
        // Repository.shared.setItemsOrder(items.flatMap { $0 }, in: currentList, forState: .toBuy)
    }

    private func updateItemInTheSameCategory(_ item: Item) {
        guard
            let categoryIndex = categories.firstIndex(where: { $0.id == item.categoryId }),
            let itemIndex = items[categoryIndex].firstIndex(where: { $0.id == item.id })
        else { return }

        items[categoryIndex].remove(at: itemIndex)
        items[categoryIndex].insert(item, at: itemIndex)

        let indexPath = IndexPath(row: itemIndex, section: categoryIndex)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    private func updateItemInDifferentCategories(_ previousItem: Item, _ newItem: Item) {
        guard
            let previousCategoryIndex = categories.firstIndex(where: { $0.id == previousItem.categoryId }),
            let previousItemIndex = items[previousCategoryIndex].firstIndex(where: { $0.id == previousItem.id }),
            let newCategoryIndex = categories.firstIndex(where: { $0.id == newItem.categoryId })
        else { return }

        updatePreviousItem(at: previousItemIndex, and: previousCategoryIndex)
        updateNewItem(newItem, at: newCategoryIndex)
        removeCategoryIfEmpty(at: previousCategoryIndex)

        // Todo: repository
        // Repository.shared.setItemsOrder(items.flatMap { $0 }, in: currentList, forState: .toBuy)
    }

    private func updatePreviousItem(at itemIndex: Int, and categoryIndex: Int) {
        items[categoryIndex].remove(at: itemIndex)

        let indexPath = IndexPath(row: itemIndex, section: categoryIndex)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    private func updateNewItem(_ item: Item, at categoryIndex: Int) {
        items[categoryIndex].insert(item, at: 0)

        let indexPath = IndexPath(row: 0, section: categoryIndex)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    private func removeCategoryIfEmpty(at categoryIndex: Int) {
        let doesItemsInCategoryExist = items[categoryIndex].count > 0
        if doesItemsInCategoryExist { return }

        items.remove(at: categoryIndex)
        categories.remove(at: categoryIndex)
        tableView.deleteSections(IndexSet(integer: categoryIndex), with: .automatic)
    }

    private func didSave(_ item: Item, setItemsAndTableView: () -> ()) {
//        if !categories.contains(item.category) {
//            append(item.category)
//        }
//
//        setItemsAndTableView()
//        refreshUserInterface()
    }
}

extension ItemsViewController: AddToBasketDelegate {
    public func addItemToBasket(_ item: ItemViewModel) {
        viewModel.addToBasketItem(with: item.id)
    }
}

extension ItemsViewController: TextFieldWithCancelDelegate {
    public func textFieldWithCancel(
        _ textFieldWithCancel: TextFieldWithCancel,
        didReturnWith text: String
    ) {
//        let item = Item.toBuy(name: text, info: "", list: currentList)

        let containsDefaultCategory = categories.first { $0.id == ItemsCategory.default.id } != nil
        if !containsDefaultCategory {
            append(.default)
        }

//        let categoryIndex = getCategoryIndex(item)
//        items[categoryIndex].insert(item, at: 0)

//        let indexPath = IndexPath(row: 0, section: categoryIndex)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.scrollToRow(at: indexPath, at: .top, animated: true)

        // Todo: repository
        // Repository.shared.add(item)

        refreshUserInterface()
    }
}

extension ItemsViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        categories.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count > 0 ? items[section].count : 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemsTableViewCell

//        cell.viewModel = items[indexPath.section][indexPath.row]
        cell.delegate = self

        return cell
    }

    public func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        var item = items[sourceIndexPath.section].remove(at: sourceIndexPath.row)

        if sourceIndexPath.section != destinationIndexPath.section {
            let destinationCategory = categories[destinationIndexPath.section]
            item = item.withChanged(categoryId: destinationCategory.id)
            let cell = tableView.cellForRow(at: sourceIndexPath) as! ItemsTableViewCell
//            cell.item = item
            // Todo: repository
            // Repository.shared.updateCategory(of: item, to: destinationCategory)
        }

        items[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
        // Todo: repository
        // Repository.shared.setItemsOrder(items.flatMap { $0 }, in: currentList, forState: .toBuy)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            let sectionIndex = sourceIndexPath.section
            guard tableView.numberOfRows(inSection: sectionIndex) == 0 else { return }

            self.items.remove(at: sectionIndex)
            self.categories.remove(at: sectionIndex)
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .middle)
        }
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

extension ItemsViewController: ItemsToolbarDelegate {
    public func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }

    public func addButtonDidTap() {
        delegate?.goToCreateItem(for: viewModel.list)
    }

    public func actionButtonDidTap() {
        let shareAction = UIAlertAction(title: "Share", style: .default) { [unowned self] _ in
            self.openShareItemsAlert()
        }

        let moveAllToBasketAction = UIAlertAction(title: "Move all to basket", style: .default) { [unowned self] _ in
            // TODO: command
            // let command = AddItemsToBasketCommand(self.items.flatMap { $0 }, self)
            // CommandInvoker.shared.execute(command)
        }

        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] _ in
            // TODO: command
            // let command = RemoveItemsFromListCommand(self.items.flatMap { $0 }, self)
            // CommandInvoker.shared.execute(command)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if self.items.count > 0 {
            alertController.addAction(shareAction)
        }

        alertController.addAction(moveAllToBasketAction)
        alertController.addAction(deleteAllAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    public func deleteAllButtonDidTap() {
        guard let selectedItems = getSelectedItems() else { return }
        // TODO: command
        // let command = RemoveItemsFromListCommand(selectedItems, self)
        // CommandInvoker.shared.execute(command)
    }

    public func moveAllToBasketButtonDidTap() {
        guard let selectedItems = getSelectedItems() else { return }
        // TODO: command
        // let command = AddItemsToBasketCommand(selectedItems, self)
        // CommandInvoker.shared.execute(command)
    }

    private func getSelectedItems() -> [Item]? {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return nil }
        return selectedIndexPaths.sorted { $0 > $1 }.map { self.items[$0.section][$0.row] }
    }

    private func openShareItemsAlert() {
        let shareWithCategories = UIAlertAction(title: "... with categories", style: .default) { [unowned self] _ in
            let formattedItems = self.sharedItemsFormatter.format(self.items, withCategories: self.categories)
            self.showActivityController(formattedItems)
        }

        let shareWithoutCategories = UIAlertAction(title: "... without categories", style: .default) { [unowned self] _ in
            let formattedItems = self.sharedItemsFormatter.format(self.items)
            self.showActivityController(formattedItems)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(title: "Share ...", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(shareWithCategories)
        alertController.addAction(shareWithoutCategories)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    private func showActivityController(_ formattedItems: String) {
        assert(!formattedItems.isEmpty, "Formatted items must have items.")
        present(UIActivityViewController(activityItems: [formattedItems], applicationActivities: nil), animated: true)
    }

    public func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshUserInterface()
    }
}
