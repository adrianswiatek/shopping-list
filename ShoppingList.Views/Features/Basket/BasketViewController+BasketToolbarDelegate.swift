import UIKit

extension BasketViewController: BasketToolbarDelegate {
    func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }
    
    func actionButtonDidTap() {
        let restoreAllAction = UIAlertAction(title: "Restore all", style: .default) { [unowned self] _ in
            let command = AddItemsBackToListCommand(self.items, self)
            CommandInvoker.shared.execute(command)
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] action in
            let command = RemoveItemsFromBasketCommand(self.items, self)
            CommandInvoker.shared.execute(command)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(restoreAllAction)
        alertController.addAction(deleteAllAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func deleteAllButtonDidTap() {
        CommandInvoker.shared.execute(RemoveItemsFromBasketCommand(getSelectedItems(), self))
    }
    
    func restoreAllButtonDidTap() {
        CommandInvoker.shared.execute(AddItemsBackToListCommand(getSelectedItems(), self))
    }
    
    private func getSelectedItems() -> [Item] {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return [] }
        return selectedIndexPaths.sorted { $0 < $1 }.map { items[$0.row] }
    }
    
    func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshUserInterface()
    }
}
