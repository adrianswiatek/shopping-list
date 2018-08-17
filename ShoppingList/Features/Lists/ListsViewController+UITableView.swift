import UIKit

extension ListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemsViewController = ItemsViewController()
        itemsViewController.delegate = self
        itemsViewController.currentList = lists[indexPath.row]
        navigationController?.pushViewController(itemsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, sourceView, completionHandler) in
            let currentList = self.lists[indexPath.row]
            if currentList.getNumberOfItemsToBuy() == 0 {
                self.deleteList(at: indexPath)
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
        deleteItemAction.image = #imageLiteral(resourceName: "Trash")
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }
    
    private func deleteList(at indexPath: IndexPath) {
        let list = lists.remove(at: indexPath.row)
        Repository.shared.remove(list)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        setScene()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editItemAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] (action, sourceView, completionHandler) in
            var builder = EditListAlertBuilder(listName: self.lists[indexPath.row].name)
            builder.saveButtonTapped = {
                self.changeListName(at: indexPath, newName: $0)
                completionHandler(true)
            }
            builder.cancelButtonTapped = { completionHandler(false) }
            self.present(builder.build(), animated: true)
        }
        editItemAction.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        editItemAction.image = #imageLiteral(resourceName: "Edit")
        return UISwipeActionsConfiguration(actions: [editItemAction])
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
