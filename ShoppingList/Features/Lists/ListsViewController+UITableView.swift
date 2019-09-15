import UIKit

extension ListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemsViewController = ItemsViewController()
        itemsViewController.delegate = self
        itemsViewController.currentList = lists[indexPath.row]
        navigationController?.pushViewController(itemsViewController, animated: true)
    }
    
    func tableView(
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
        deleteItemAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        deleteItemAction.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }
    
    private func deleteList(at indexPath: IndexPath) {
        let list = lists.remove(at: indexPath.row)
        Repository.shared.remove(list)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        refreshUserInterface()
    }

    func tableView(
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
        action.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.4980392157, blue: 0.7568627451, alpha: 1)
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
        action.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.8117647059, blue: 0.7568627451, alpha: 1)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListsTableViewCell
        cell.list = lists[indexPath.row]
        return cell
    }
}
