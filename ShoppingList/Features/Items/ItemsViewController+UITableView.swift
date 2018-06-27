import UIKit

extension ItemsViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editItemAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] (action, sourceView, completionHandler) in
            let item = self.items[indexPath.section][indexPath.row]
            self.goToEditItemDetailed(with: item)
            completionHandler(true)
        }
        editItemAction.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        editItemAction.image = #imageLiteral(resourceName: "Edit")
        return UISwipeActionsConfiguration(actions: [editItemAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItemAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, sourceView, completionHandler) in
            let item = self.items[indexPath.section].remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            Repository.shared.remove(item)
            Repository.shared.setItemsOrder(self.items.flatMap { $0 }, in: self.list, forState: .toBuy)
            
            self.refreshUserInterface(after: 0.5)
            completionHandler(true)
        }
        deleteItemAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        deleteItemAction.image = #imageLiteral(resourceName: "Trash")
        return UISwipeActionsConfiguration(actions: [deleteItemAction])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ItemsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count > 0 ? items[section].count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.item = items[indexPath.section][indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var item = items[sourceIndexPath.section].remove(at: sourceIndexPath.row)

        if sourceIndexPath.section != destinationIndexPath.section {
            let destinationCategory = categories[destinationIndexPath.section]
            item = item.getWithChanged(category: destinationCategory)
            let cell = tableView.cellForRow(at: sourceIndexPath) as! ItemTableViewCell
            cell.item = item
            Repository.shared.updateCategory(of: item, to: destinationCategory)
        }

        items[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
        Repository.shared.setItemsOrder(items.flatMap { $0 }, in: list, forState: .toBuy)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            let sectionIndex = sourceIndexPath.section
            if tableView.numberOfRows(inSection: sectionIndex) == 0 {
                self.items.remove(at: sectionIndex)
                self.categories.remove(at: sectionIndex)
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .middle)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ItemsViewController: UITableViewDragDelegate {
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension ItemsViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
    
    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
