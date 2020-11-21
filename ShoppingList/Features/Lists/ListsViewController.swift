import UIKit

public final class ListsViewController: UIViewController {
    public var lists = [List]()

    public let tableView: UITableView = configure(UITableView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tableFooterView = UIView()
        $0.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler)))
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 90
        $0.backgroundColor = .background
    }

    private lazy var addListTextFieldWithCancel: TextFieldWithCancel = {
        let textFieldWithCancel = TextFieldWithCancel(viewController: self, placeHolder: "Add new list...")
        textFieldWithCancel.delegate = self
        textFieldWithCancel.layer.zPosition = 1
        textFieldWithCancel.translatesAutoresizingMaskIntoConstraints = false
        return textFieldWithCancel
    }()
    
    @objc
    private func longPressHandler(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchLocation = gesture.location(in: tableView)
        guard let touchedRow = tableView.indexPathForRow(at: touchLocation)?.row else { return }
        
        var alertController = ListActionsAlertBuilder(lists[touchedRow])
        alertController.delegate = self
        
        present(alertController.build(), animated: true)
    }
    
    private lazy var goToSettingsBarButtonItem: UIBarButtonItem =
        .init(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(goToSettingsScene))
    
    @objc
    private func goToSettingsScene() {
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        present(navigationController, animated: true)
    }
    
    private lazy var restoreBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Restore"), style: .plain, target: self, action: #selector(restore))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    @objc
    private func restore() {
        let invoker = CommandInvoker.shared
        if invoker.canUndo(.lists) {
            invoker.undo(.lists)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        fetchLists()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CommandInvoker.shared.remove(.lists)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        refreshUserInterface()
    }

    public func refreshUserInterface() {
        if !lists.isEmpty {
            tableView.backgroundView = nil
        } else {
            tableView.setTextIfEmpty("You have not added any lists yet")
        }

        restoreBarButtonItem.isEnabled = CommandInvoker.shared.canUndo(.lists)
        navigationItem.rightBarButtonItems = [goToSettingsBarButtonItem, restoreBarButtonItem]
    }

    private func setupView() {
        navigationItem.title = "My lists"
        
        view.addSubview(addListTextFieldWithCancel)
        NSLayoutConstraint.activate([
            addListTextFieldWithCancel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addListTextFieldWithCancel.topAnchor.constraint(equalTo: view.topAnchor),
            addListTextFieldWithCancel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addListTextFieldWithCancel.heightAnchor.constraint(equalToConstant: 50),
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: addListTextFieldWithCancel.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.register(ListsTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func fetchLists() {
        lists = Repository.shared.getLists().sorted { $0.updateDate > $1.updateDate }
    }
    
    private func getListName(from text: String) -> String {
        ListNameGenerator().generate(from: text, and: lists)
    }
}

extension ListsViewController: ItemsViewControllerDelegate {
    func itemsViewControllerDidDismiss(_ itemsViewController: ItemsViewController) {
        fetchLists()
        tableView.reloadData()
    }
}

extension ListsViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let list = List.new(name: getListName(from: text))

        lists.insert(list, at: 0)
        Repository.shared.add(list)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        refreshUserInterface()
    }
}

extension ListsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let itemsViewController = ItemsViewController()
        itemsViewController.delegate = self
        itemsViewController.currentList = lists[indexPath.row]
        navigationController?.pushViewController(itemsViewController, animated: true)
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(
            style: .destructive,
            title: nil) { [unowned self] (action, sourceView, completionHandler) in
            let currentList = self.lists[indexPath.row]
            if currentList.getNumberOfItemsToBuy() == 0 {
                let command = RemoveListCommand(currentList, self)
                CommandInvoker.shared.execute(command)
                completionHandler(true)
                return
            }

            var builder = DeleteListAlertBuilder()
            builder.deleteButtonTapped = {
                self.deleteList(at: indexPath)
                completionHandler(true)
            }
            builder.cancelButtonTapped = { completionHandler(false) }
            self.present(builder.build(), animated: true)
        }
        deleteItemAction.backgroundColor = .delete
        deleteItemAction.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }

    private func deleteList(at indexPath: IndexPath) {
        let list = lists.remove(at: indexPath.row)
        Repository.shared.remove(list)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        refreshUserInterface()
    }

    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            getEditItemAction(for: indexPath),
            getShareItemAction(for: indexPath)
        ])
    }

    private func getEditItemAction(for indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(
            style: .normal,
            title: nil) { [unowned self] (action, sourceView, completionHandler) in
            self.showEditPopup(
                list: self.lists[indexPath.row],
                saved: {
                    guard !$0.isEmpty else {
                        completionHandler(false)
                        return
                    }
                    self.changeListName(at: indexPath, newName: $0)
                    completionHandler(true)
                },
                cancelled: {
                    completionHandler(false)
                })
        }
        action.backgroundColor = .edit
        action.image = #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate)

        return action
    }

    private func getShareItemAction(for indexPath: IndexPath) -> UIContextualAction {
        let list = lists[indexPath.row]

        let action = UIContextualAction(
            style: .normal,
            title: nil) { [unowned self] _, _, completionHandler in
            let updatedList = list.with(accessType: list.accessType == .private ? .shared : .private)
            self.lists[indexPath.row] = updatedList
            completionHandler(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        action.backgroundColor = .share
        action.image = (list.accessType == .private ? #imageLiteral(resourceName: "ShareWith") : #imageLiteral(resourceName: "Locked")).withRenderingMode(.alwaysTemplate)

        return action
    }

    private func showEditPopup(
        list: List,
        saved: @escaping (String) -> Void,
        cancelled: @escaping () -> Void
    ) {
        let controller = PopupWithTextFieldController()
        controller.modalPresentationStyle = .overFullScreen
        controller.popupTitle = "Edit List"
        controller.placeholder = "Enter list name..."
        controller.text = list.name
        controller.saved = saved
        controller.cancelled = cancelled
        present(controller, animated: true)
    }

    private func changeListName(at indexPath: IndexPath, newName: String) {
        let existingList = lists[indexPath.row]
        guard existingList.name != newName else { return }

        let listWithChangedName = existingList.getWithChanged(name: getListName(from: newName))

        lists.remove(at: indexPath.row)
        lists.insert(listWithChangedName, at: 0)

        Repository.shared.update(listWithChangedName)

        if indexPath.row == 0 {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let zeroIndexPath = IndexPath(row: 0, section: 0)
            tableView.moveRow(at: indexPath, to: zeroIndexPath)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.tableView.reloadRows(at: [zeroIndexPath], with: .automatic)
            }
        }
    }
}

extension ListsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListsTableViewCell
        cell.list = lists[indexPath.row]
        return cell
    }
}

extension ListsViewController: ListsActionsAlertDelegate {
    public func deleteAllItemsIn(_ list: List) {
        remove(items: list.items, from: list)
    }

    public func emptyBasketIn(_ list: List) {
        remove(items: list.items.filter { $0.state == .inBasket }, from: list)
    }

    private func remove(items: [Item], from list: List) {
        guard let index = lists.firstIndex(where: { $0.id == list.id }) else { return }

        Repository.shared.remove(items)

        guard let removedList = Repository.shared.getList(by: list.id) else { return }
        lists.remove(at: index)
        lists.insert(removedList, at: 0)

        let indexPath = IndexPath(row: index, section: 0)

        if index == 0 {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let zeroIndexPath = IndexPath(row: 0, section: 0)
            tableView.moveRow(at: indexPath, to: zeroIndexPath)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.tableView.reloadRows(at: [zeroIndexPath], with: .automatic)
            }
        }
    }
}
