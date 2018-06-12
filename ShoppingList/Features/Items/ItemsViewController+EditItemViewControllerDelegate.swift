import UIKit

extension ItemsViewController: EditItemViewControllerDelegate {
    func didSave(_ item: Item) {
        let itemCategory = item.category ?? Category.getDefault()
        
        if !categories.contains(itemCategory) {
            categories.append(itemCategory)
            categories.sort { $0.name < $1.name }
            
            let categoryIndex = getCategoryIndex(item: item)
            items.insert([Item](), at: categoryIndex)
            tableView.insertSections(IndexSet(integer: categoryIndex), with: .automatic)
        }
        
        let categoryIndex = getCategoryIndex(item: item)
        items[categoryIndex].insert(item, at: 0)
        
        let indexPath = IndexPath(row: 0, section: categoryIndex)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        refreshScene()
    }
}
