import ShoppingList_Domain
import ShoppingList_Shared
import UIKit

public final class BasketViewController: UIViewController {
    var items = [Item]()
    var list: List!
    
    lazy var tableView: UITableView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.dragDelegate = self
        $0.dropDelegate = self
        $0.allowsSelection = false
        $0.dragInteractionEnabled = true
        $0.allowsMultipleSelectionDuringEditing = true
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 50
        $0.tableFooterView = UIView()
        $0.register(BasketTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    lazy var toolbar: BasketToolbar = configure(.init(viewController: self)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
    }
    
    private lazy var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), style: .plain, target: self, action: #selector(restore))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    @objc
    private func restore() {
        // Todo: command
        // let invoker = CommandInvoker.shared
        // if invoker.canUndo(.basket) {
        //     invoker.undo(.basket)
        // }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        validateStartingContract()
        setupUserInterface()
    }
    
    private func validateStartingContract() {
        guard list != nil else { fatalError("Found nil in starting contract.") }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
        refreshUserInterface()
        tableView.reloadData()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Todo: command
        // CommandInvoker.shared.remove(.basket)
    }
    
    private func fetchItems() {
        // Todo: repository
        // items = Repository.shared.getItemsWith(state: .inBasket, in: list)
    }
    
    private func setupUserInterface() {
        title = "Basket"
        
        view.addSubview(toolbar)
        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
    }
    
    func refreshUserInterface() {
        items.count > 0 ? setSceneAsEditable() : setSceneAsNotEditable()

        // Todo: repository
        // restoreBarButtonItem.isEnabled = CommandInvoker.shared.canUndo(.basket)
        navigationItem.rightBarButtonItem = restoreBarButtonItem
    }
    
    private func setSceneAsEditable() {
        toolbar.setRegularMode()
        toolbar.setButtonsAs(enabled: true)
        tableView.setEditing(false, animated: true)
        tableView.backgroundView = nil
    }
    
    private func setSceneAsNotEditable() {
        toolbar.setRegularMode()
        toolbar.setButtonsAs(enabled: false)
        tableView.setEditing(false, animated: true)
        tableView.setTextIfEmpty("Your basket is empty")
    }
}

extension BasketViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(style: .destructive, title: nil) { [unowned self] (action, sourceView, completionHandler) in
            let item = self.items[indexPath.row]
            // Todo: command
            // let command = RemoveItemsFromBasketCommand(item, self)
            // CommandInvoker.shared.execute(command)
            completionHandler(true)
        }
        deleteItemAction.backgroundColor = .delete
        deleteItemAction.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }
}

extension BasketViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BasketTableViewCell

        cell.item = items[indexPath.row]
        cell.delegate = self

        return cell
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !tableView.isEditing
    }

    public func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        let item = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(item, at: destinationIndexPath.row)
        // Todo: repository
        // Repository.shared.setItemsOrder(items, in: list, forState: .inBasket)
    }
}

extension BasketViewController: UITableViewDragDelegate {
    public func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension BasketViewController: UITableViewDropDelegate {
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}

    public func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

extension BasketViewController: BasketToolbarDelegate {
    public func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }

    public func actionButtonDidTap() {
        let restoreAllAction = UIAlertAction(title: "Restore all", style: .default) { [unowned self] _ in
            // Todo: command
            // let command = AddItemsBackToListCommand(self.items, self)
            // CommandInvoker.shared.execute(command)
        }

        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] action in
            // Todo: command
            // let command = RemoveItemsFromBasketCommand(self.items, self)
            // CommandInvoker.shared.execute(command)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(restoreAllAction)
        alertController.addAction(deleteAllAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    public func deleteAllButtonDidTap() {
        // Todo: command
        // CommandInvoker.shared.execute(RemoveItemsFromBasketCommand(getSelectedItems(), self))
    }

    public func restoreAllButtonDidTap() {
        // Todo: command
        // CommandInvoker.shared.execute(AddItemsBackToListCommand(getSelectedItems(), self))
    }

    private func getSelectedItems() -> [Item] {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return [] }
        return selectedIndexPaths.sorted { $0 < $1 }.map { items[$0.row] }
    }

    public func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshUserInterface()
    }
}

extension BasketViewController: RemoveFromBasketDelegate {
    public func removeItemFromBasket(_ item: Item) {
        // Todo: command
        // let command = AddItemsBackToListCommand(item, self)
        // CommandInvoker.shared.execute(command)
    }
}
