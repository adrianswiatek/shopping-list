import UIKit

extension BasketViewController: BasketToolbarDelegate {
    func editButtonDidTap() {
        tableView.setEditing(true, animated: true)
        toolbar.setEditMode()
    }
    
    func actionButtonDidTap() {
        let restoreAllAction = UIAlertAction(title: "Restore all", style: .default) { [unowned self] action in
            let indicesOfRestoredItems = (0..<self.items.count).map { $0 }
            self.items.removeAll()
            
            self.tableView.deleteRows(at: indicesOfRestoredItems, with: .left)
            Repository.shared.updateState(of: self.items, to: .toBuy)
            
            self.refreshScene()
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] action in
            let indicesOfRemovedItems = (0..<self.items.count).map { $0 }
            self.items.removeAll()
            
            self.tableView.deleteRows(at: indicesOfRemovedItems)
            Repository.shared.remove(self.items)
            
            self.refreshScene()
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
        
        let selectedRows = selectedIndexPaths.map { $0.row }
        var selectedItems = [Item]()
        
        for selectedRow in selectedRows {
            selectedItems.append(items.remove(at: selectedRow))
        }
        
        tableView.deleteRows(at: selectedRows)
        Repository.shared.remove(selectedItems)
        
        setToolbarButtonsEditability(with: tableView)
    }
    
    func restoreAllButtonDidTap() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let selectedRows = selectedIndexPaths.map { $0.row }
        var selectedItems = [Item]()
        
        for selectedRow in selectedRows {
            selectedItems.append(items.remove(at: selectedRow))
        }
        
        tableView.deleteRows(at: selectedRows, with: .left)
        Repository.shared.updateState(of: selectedItems, to: .toBuy)
        
        setToolbarButtonsEditability(with: tableView)
    }
    
    func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshScene()
    }
}
