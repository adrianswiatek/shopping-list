import UIKit

extension ItemsViewController: ItemsToolbarDelegate {
    func editButtonDidTap() {
        toolbar.setEditMode()
        tableView.setEditing(true, animated: true)
    }
    
    func actionButtonDidTap() {
        let moveAllToBasketAction = UIAlertAction(title: "Move all to basket", style: .default) { [unowned self] action in
            let itemsToMove = self.items
            
            var indexPaths = [IndexPath]()
            let sectionNumbers = 0..<self.categories.count
            for sectionNumber in sectionNumbers {
                let rowNumbers = 0..<self.items[sectionNumber].count
                for rowNumber in rowNumbers {
                    indexPaths.append(IndexPath(row: rowNumber, section: sectionNumber))
                }
            }
            
            self.items.removeAll()
            self.tableView.deleteRows(at: indexPaths, with: .right)
            Repository.shared.updateState(of: itemsToMove.flatMap { $0 }, to: .inBasket)
            
            self.refreshScene()
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] action in
            let itemsToDelete = self.items
            
            var indexPaths = [IndexPath]()
            let sectionNumbers = 0..<self.categories.count
            for sectionNumber in sectionNumbers {
                let rowNumbers = 0..<self.items[sectionNumber].count
                for rowNumber in rowNumbers {
                    indexPaths.append(IndexPath(row: rowNumber, section: sectionNumber))
                }
            }
            
            self.items.removeAll()
            self.tableView.deleteRows(at: indexPaths, with: .automatic)
            Repository.shared.remove(itemsToDelete.flatMap { $0 })
            
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
        
        let selectedItems = selectedIndexPaths.map { self.items[$0.section].remove(at: $0.row) }
        tableView.deleteRows(at: selectedIndexPaths, with: .automatic)
        Repository.shared.remove(selectedItems)
        
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
        
        self.refreshScene()
    }
    
    func moveAllToBasketButtonDidTap() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let selectedItems = selectedIndexPaths
            .sorted { $0 > $1 }
            .map { self.items[$0.section].remove(at: $0.row) }
        tableView.deleteRows(at: selectedIndexPaths, with: .right)
        Repository.shared.updateState(of: selectedItems, to: .inBasket)
        
        toolbar.setButtonsAs(enabled: tableView.indexPathsForSelectedRows != nil)
        
        self.refreshScene()
    }
    
    func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshScene()
    }
}
