import UIKit

extension ItemsViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let item = Item.toBuy(name: text, list: list)
        
        if !categories.containsDefaultCategory() {
            categories.append(Category.getDefault())
            categories.sort { $0.name < $1.name }
            
            let index = getCategoryIndex(item: item)
            items.insert([Item](), at: index)
            tableView.insertSections(IndexSet(integer: index), with: .automatic)
        }
        
        let categoryIndex = getCategoryIndex(item: item)
        items[categoryIndex].insert(item, at: 0)
        
        let indexPath = IndexPath(row: 0, section: categoryIndex)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        Repository.shared.add(item)
        
        refreshScene()
    }
    
    func getCategoryIndex(item: Item) -> Int {
        let category = item.category ?? Category.getDefault()
        
        guard let index = categories.index (where: { $0.id == category.id }) else {
            fatalError("Unable to find category index.")
        }
        
        return index
    }
}
