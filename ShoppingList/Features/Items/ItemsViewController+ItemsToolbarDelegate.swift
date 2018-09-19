import UIKit

extension ItemsViewController: ItemsToolbarDelegate {
    func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }
    
    func addButtonDidTap() {
        goToEditItemDetailed()
    }
    
    func actionButtonDidTap() {
        let moveAllToBasketAction = UIAlertAction(title: "Move all to basket", style: .default) { [unowned self] action in
            let command = AddItemsToBasketCommand(self.items.flatMap { $0 }, self)
            CommandInvoker.shared.execute(command)
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] action in
            let command = RemoveItemsFromListCommand(self.items.flatMap { $0 }, self)
            CommandInvoker.shared.execute(command)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
    
    func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshUserInterface()
    }
}
