import ShoppingList_Domain
import UIKit

public final class ItemsViewController: UIViewController {
    let sharedItemsFormatter = SharedItemsFormatter()
    var delegate: ItemsViewControllerDelegate!
    
    var currentList: List!
    
    var items = [[Item]]()
    var categories = [ItemsCategory]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.dragInteractionEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(ItemsTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var addItemTextField: TextFieldWithCancel = {
        let textField = TextFieldWithCancel(viewController: self, placeHolder: "Add new item...")
        textField.delegate = self
        textField.set(ValidationButtonRuleLeaf.getNotEmptyItemRule())
        textField.layer.zPosition = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var toolbar: ItemsToolbar = {
        let toolbar = ItemsToolbar(viewController: self)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.delegate = self
        return toolbar
    }()
    
    lazy var goToFilledBasketBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "Basket"), style: .plain, target: self, action: #selector(goToBasketScene))
    }()
    
    lazy var goToEmptyBasketBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "EmptyBasket"), style: .plain, target: self, action: #selector(goToBasketScene))
    }()
    
    @objc private func goToBasketScene() {
        let basketViewController = BasketViewController()
        basketViewController.list = currentList
        navigationController?.pushViewController(basketViewController, animated: true)
    }
    
    lazy var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), style: .plain, target: self, action: #selector(restore))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()

    @objc private func restore() {
        // Todo: command
        // let invoker = CommandInvoker.shared
        // if invoker.canUndo(.items) {
        //     invoker.undo(.items)
        // }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        validateStartingContract()
        setupUserInterface()
    }
    
    private func validateStartingContract() {
        guard delegate != nil, currentList != nil else {
            fatalError("Found nil in starting contract.")
        }
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
            delegate.itemsViewControllerDidDismiss(self)
        }

        // Todo: command
        // CommandInvoker.shared.remove(.items)
    }
    
    public func fetchItems() {
        // Todo: repository
        // let allItems = Repository.shared.getItemsWith(state: .toBuy, in: currentList)
        let allItems: [Item] = []
        var items = [[Item]]()
        self.categories = Set(allItems.map { $0.category }).sorted { $0.name < $1.name }
        
        for category in categories {
            let itemsInCategory = allItems.filter { $0.categoryName() == category.name }
            items.append(itemsInCategory)
        }
        
        self.items = items
    }
    
    private func setupUserInterface() {
        navigationItem.title = currentList.name

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
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addItemTextField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func refreshUserInterface(after: Double = 0) {
        setTopBarButtons()
        
        items.count > 0 ? setSceneAsEditable() : setSceneAsNotEditable()
        tableView.setEditing(false, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
            self?.clearCategoriesIfNeeded()
        }
    }
    
    private func setTopBarButtons() {
        // Todo: repository
        // let numberOfItemsInBasket = Repository.shared.getNumberOfItemsWith(state: .inBasket, in: currentList)
        let numberOfItemsInBasket = 0
        let basketBarButtonItem = numberOfItemsInBasket > 0
            ? goToFilledBasketBarButtonItem
            : goToEmptyBasketBarButtonItem

        // Todo: command
        // restoreBarButtonItem.isEnabled = CommandInvoker.shared.canUndo(.items)
        
        navigationItem.rightBarButtonItems = [ basketBarButtonItem, restoreBarButtonItem ]
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
            let range = 0..<categories.count
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
    
    func goToEditItemDetailed(with item: Item? = nil) {
        let viewController = EditItemViewController()
        viewController.delegate = self
        viewController.list = currentList
        viewController.item = item
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        
        present(navigationController, animated: true)
    }
    
    func append(_ category: ItemsCategory) {
        categories.append(category)
        categories.sort { $0.name < $1.name }
        
        let categoryIndex = getCategoryIndex(category)
        items.insert([Item](), at: categoryIndex)
        tableView.insertSections(IndexSet(integer: categoryIndex), with: .automatic)
    }
    
    func getCategoryIndex(_ item: Item) -> Int {
        getCategoryIndex(item.category)
    }
    
    func getCategoryIndex(_ category: ItemsCategory) -> Int {
        guard let index =  categories.firstIndex (where: { $0.id == category.id }) else {
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
            let isBeingUpdatedInTheSameList = previousItem.list.id == newItem.list.id
            if !isBeingUpdatedInTheSameList {
                moveToOtherList(previousItem)
                return
            }

            let isBeingUpdatedInTheSameCategory = previousItem.category.id == newItem.category.id
            isBeingUpdatedInTheSameCategory
                ? updateItemInTheSameCategory(newItem)
                : updateItemInDifferentCategories(previousItem, newItem)
        }
    }

    private func moveToOtherList(_ item: Item) {
        guard
            let categoryIndex = categories.firstIndex(where: { $0.id == item.category.id }),
            let itemIndex = items[categoryIndex].firstIndex(where: { $0.id == item.id })
        else { return }

        updatePreviousItem(at: itemIndex, and: categoryIndex)
        removeCategoryIfEmpty(at: categoryIndex)

        // Todo: repository
        // Repository.shared.setItemsOrder(items.flatMap { $0 }, in: currentList, forState: .toBuy)
    }

    private func updateItemInTheSameCategory(_ item: Item) {
        guard
            let categoryIndex = categories.firstIndex(where: { $0.id == item.category.id }),
            let itemIndex = items[categoryIndex].firstIndex(where: { $0.id == item.id })
        else { return }

        items[categoryIndex].remove(at: itemIndex)
        items[categoryIndex].insert(item, at: itemIndex)

        let indexPath = IndexPath(row: itemIndex, section: categoryIndex)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    private func updateItemInDifferentCategories(_ previousItem: Item, _ newItem: Item) {
        guard
            let previousCategoryIndex = categories.firstIndex(where: { $0.id == previousItem.category.id }),
            let previousItemIndex = items[previousCategoryIndex].firstIndex(where: { $0.id == previousItem.id }),
            let newCategoryIndex = categories.firstIndex(where: { $0.id == newItem.category.id })
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
        if !categories.contains(item.category) {
            append(item.category)
        }

        setItemsAndTableView()
        refreshUserInterface()
    }
}

extension ItemsViewController: AddToBasketDelegate {
    public func addItemToBasket(_ item: Item) {
        // TODO: command
        // let command = AddItemsToBasketCommand(item, self)
        // CommandInvoker.shared.execute(command)
    }
}

extension ItemsViewController: TextFieldWithCancelDelegate {
    public func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let item = Item.toBuy(name: text, info: "", list: currentList)

        let containsDefaultCategory = categories.first { $0.id == ItemsCategory.default.id } != nil
        if !containsDefaultCategory {
            append(.default)
        }

        let categoryIndex = getCategoryIndex(item)
        items[categoryIndex].insert(item, at: 0)

        let indexPath = IndexPath(row: 0, section: categoryIndex)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)

        // Todo: repository
        // Repository.shared.add(item)

        refreshUserInterface()
    }
}

extension ItemsViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let editItemAction = UIContextualAction(
            style: .normal,
            title: nil) { [unowned self] (action, sourceView, completionHandler) in
            let item = self.items[indexPath.section][indexPath.row]
            self.goToEditItemDetailed(with: item)
            completionHandler(true)
        }
        editItemAction.backgroundColor = .edit
        editItemAction.image = #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [editItemAction])
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [unowned self] (action, sourceView, completionHandler) in
            // Todo: command
            // let item = self.items[indexPath.section][indexPath.row]
            // let command = RemoveItemsFromListCommand(item, self)
            // CommandInvoker.shared.execute(command)
            completionHandler(true)
        }
        deleteItemAction.backgroundColor = .delete
        deleteItemAction.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = ItemsTableViewHeaderCell()
        headerCell.category = categories[section]
        return headerCell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }
}

extension ItemsViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count > 0 ? items[section].count : 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemsTableViewCell

        cell.item = items[indexPath.section][indexPath.row]
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
            item = item.getWithChanged(category: destinationCategory)
            let cell = tableView.cellForRow(at: sourceIndexPath) as! ItemsTableViewCell
            cell.item = item
            // Todo: repository
            // Repository.shared.updateCategory(of: item, to: destinationCategory)
        }

        items[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
        // Todo: repository
        // Repository.shared.setItemsOrder(items.flatMap { $0 }, in: currentList, forState: .toBuy)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            let sectionIndex = sourceIndexPath.section
            if tableView.numberOfRows(inSection: sectionIndex) == 0 {
                self.items.remove(at: sectionIndex)
                self.categories.remove(at: sectionIndex)
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .middle)
            }
        }
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ItemsViewController: UITableViewDragDelegate {
    public func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension ItemsViewController: UITableViewDropDelegate {
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}

    public func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

extension ItemsViewController: ItemsToolbarDelegate {
    public func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }

    public func addButtonDidTap() {
        goToEditItemDetailed()
    }

    public func actionButtonDidTap() {
        let shareAction = UIAlertAction(title: "Share", style: .default) { [unowned self] _ in
            self.openShareItemsAlert()
        }

        let moveAllToBasketAction = UIAlertAction(title: "Move all to basket", style: .default) { [unowned self] _ in
            let command = AddItemsToBasketCommand(self.items.flatMap { $0 }, self)
            CommandInvoker.shared.execute(command)
        }

        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] _ in
            let command = RemoveItemsFromListCommand(self.items.flatMap { $0 }, self)
            CommandInvoker.shared.execute(command)
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

    func deleteAllButtonDidTap() {
        guard let selectedItems = getSelectedItems() else { return }
        let command = RemoveItemsFromListCommand(selectedItems, self)
        CommandInvoker.shared.execute(command)
    }

    func moveAllToBasketButtonDidTap() {
        guard let selectedItems = getSelectedItems() else { return }
        let command = AddItemsToBasketCommand(selectedItems, self)
        CommandInvoker.shared.execute(command)
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

    func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshUserInterface()
    }
}
