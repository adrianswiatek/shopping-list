import UIKit

extension ItemsViewController: EditItemViewControllerDelegate {
    func didCreate(_ item: Item) {
        didSave(item) {
            let categoryIndex = getCategoryIndex(item: item)
            items[categoryIndex].insert(item, at: 0)
            
            let indexPath = IndexPath(row: 0, section: categoryIndex)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func didUpdate(_ previousItem: Item, _ newItem: Item) {
        didSave(newItem) {
            let isBeingUpdatedInTheSameCategory = previousItem.getCategory().id == newItem.getCategory().id
            isBeingUpdatedInTheSameCategory
                ? updateItemInTheSameCategory(newItem)
                : updateItemInDifferentCategories(previousItem, newItem)
        }
    }
    
    func updateItemInTheSameCategory(_ item: Item) {
        guard
            let categoryIndex = categories.index(where: { $0.id == item.getCategory().id }),
            let itemIndex = items[categoryIndex].index(where: { $0.id == item.id })
        else { return }
        
        items[categoryIndex].remove(at: itemIndex)
        items[categoryIndex].insert(item, at: itemIndex)
        
        let indexPath = IndexPath(row: itemIndex, section: categoryIndex)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func updateItemInDifferentCategories(_ previousItem: Item, _ newItem: Item) {
        guard
            let previousCategoryIndex = categories.index(where: { $0.id == previousItem.getCategory().id }),
            let previousItemIndex = items[previousCategoryIndex].index(where: { $0.id == previousItem.id }),
            let newCategoryIndex = categories.index(where: { $0.id == newItem.getCategory().id })
        else { return }
        
        updatePreviousItem(at: previousItemIndex, and: previousCategoryIndex)
        updateNewItem(newItem, at: newCategoryIndex)
        removeCategoryIfEmpty(at: previousCategoryIndex)
 
        Repository.shared.setItemsOrder(items.flatMap { $0 }, forState: .toBuy)
    }
    
    private func updatePreviousItem(at itemIndex: Int, and categoryIndex: Int) {
        items[categoryIndex].remove(at: itemIndex)
        
        let indexPathOfPreviousItem = IndexPath(row: itemIndex, section: categoryIndex)
        tableView.deleteRows(at: [indexPathOfPreviousItem], with: .automatic)
    }
    
    private func updateNewItem(_ item: Item, at categoryIndex: Int) {
        items[categoryIndex].insert(item, at: 0)
        
        let indexPathOfNewItem = IndexPath(row: 0, section: categoryIndex)
        tableView.insertRows(at: [indexPathOfNewItem], with: .automatic)
    }
    
    private func removeCategoryIfEmpty(at categoryIndex: Int) {
        let doesItemsInCategoryExist = items[categoryIndex].count > 0
        if doesItemsInCategoryExist { return }
        
        items.remove(at: categoryIndex)
        categories.remove(at: categoryIndex)
        tableView.deleteSections(IndexSet(integer: categoryIndex), with: .automatic)
    }
    
    private func didSave(_ item: Item, setItemsAndTableView: () -> ()) {
        let itemCategory = item.category ?? Category.getDefault()
        
        if !categories.contains(itemCategory) {
            categories.append(itemCategory)
            categories.sort { $0.name < $1.name }
            
            let categoryIndex = getCategoryIndex(item: item)
            items.insert([Item](), at: categoryIndex)
            tableView.insertSections(IndexSet(integer: categoryIndex), with: .automatic)
        }
        
        setItemsAndTableView()
        refreshScene()
    }
}
