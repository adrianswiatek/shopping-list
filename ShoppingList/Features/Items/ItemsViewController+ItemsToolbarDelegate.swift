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
        let shareAction = UIAlertAction(title: "Share", style: .default) { [unowned self] _ in
            self.openShareItemsAlert()
        }

        let moveAllToBasketAction = UIAlertAction(title: "Move all to basket", style: .default) { [unowned self] _ in
            let command = AddItemsToBasketCommand(self.items.flatMap { $0 }, self)
            CommandInvoker.shared.execute(command)
        }
        
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] _ in
            let command = RemoveItemsFromListCommand(self.items.flatMap { $0 }, self)
            CommandInvoker.shared.execute(command)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if self.items.count > 0 {
            alertController.addAction(shareAction)
        }

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

    private func openShareItemsAlert() {
        let shareWithCategories = UIAlertAction(title: "... with categories", style: .default) { [unowned self] _ in
            let formattedItems = self.sharedItemsFormatter.format(self.items, withCategories: self.categories)
            self.showActivityController(formattedItems)
        }

        let shareWithoutCategories = UIAlertAction(title: "... without categories", style: .default) { [unowned self] _ in
            let formattedItems = self.sharedItemsFormatter.format(self.items)
            self.showActivityController(formattedItems)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(title: "Share ...", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(shareWithCategories)
        alertController.addAction(shareWithoutCategories)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    private func showActivityController(_ formattedItems: String) {
        assert(!formattedItems.isEmpty, "Formatted items must have items.")
        present(UIActivityViewController(activityItems: [formattedItems], applicationActivities: nil), animated: true)
    }

    func cancelButtonDidTap() {
        tableView.setEditing(false, animated: true)
        toolbar.setRegularMode()
        refreshUserInterface()
    }
}
