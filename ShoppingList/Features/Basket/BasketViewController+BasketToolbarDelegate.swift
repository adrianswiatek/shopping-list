import UIKit

extension BasketViewController: BasketToolbarDelegate {
    func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }
    
    func actionButtonDidTap() {
        let restoreAllAction = UIAlertAction(title: "Restore all", style: .default) { [unowned self] _ in
            let command = AddAllItemsBackToListCommand(self.items, self)
            CommandInvoker.shared.execute(command)
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] action in
            let command = RemoveAllItemsFromBasketCommand(self.items, self)
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
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let selectedItems = selectedIndexPaths
            .sorted { $0 > $1 }
            .map { items.remove(at: $0.row) }
        
        tableView.deleteRows(at: selectedIndexPaths, with: .automatic)
        
        Repository.shared.remove(selectedItems)
        Repository.shared.setItemsOrder(items, in: list, forState: .inBasket)
        
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
        
        self.refreshUserInterface()
    }
    
    func restoreAllButtonDidTap() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let selectedItems = selectedIndexPaths
            .sorted { $0 > $1 }
            .map { items.remove(at: $0.row) }
        
        tableView.deleteRows(at: selectedIndexPaths, with: .left)
        
        Repository.shared.updateState(of: selectedItems, to: .toBuy)
        Repository.shared.setItemsOrder(items, in: list, forState: .inBasket)
        
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
        
        self.refreshUserInterface()
    }
    
    func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshUserInterface()
    }
}
