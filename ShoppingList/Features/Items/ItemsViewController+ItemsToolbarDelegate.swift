import UIKit

extension ItemsViewController: ItemsToolbarDelegate {
    func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }
    
    func actionButtonDidTap() {
        let moveAllToBasketAction = UIAlertAction(title: "Move all to basket", style: .default) { [unowned self] action in
            let itemsToMove = self.items
            
            self.items.removeAll()
            
            let indicesOfMovedItems = (0..<itemsToMove.count).map { $0 }
            self.tableView.deleteRows(at: indicesOfMovedItems, with: .right)
            
            Repository.shared.updateState(of: itemsToMove, to: .inBasket)
            
            self.refreshScene()
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] action in
            let itemsToDelete = self.items
            
            self.items.removeAll()
            
            let indicesOfRemovedItems = (0..<itemsToDelete.count).map { $0 }
            self.tableView.deleteRows(at: indicesOfRemovedItems)
            
            Repository.shared.remove(itemsToDelete)
            
            self.refreshScene()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(moveAllToBasketAction)
        alertController.addAction(deleteAllAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func deleteAllButtonDidTap() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let selectedRows = selectedIndexPaths.map { $0.row }
        let selectedItems = selectedRows.map { items.remove(at: $0) }
        
        tableView.deleteRows(at: selectedRows)
        Repository.shared.remove(selectedItems)
        
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }
    
    func moveAllToBasketButtonDidTap() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let selectedRows = selectedIndexPaths.map { $0.row }
        let selectedItems = selectedRows.map { items.remove(at: $0) }
        
        tableView.deleteRows(at: selectedRows, with: .right)
        Repository.shared.updateState(of: selectedItems, to: .inBasket)
        
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
    }
    
    func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshScene()
    }
}
