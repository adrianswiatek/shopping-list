import UIKit

extension ItemsViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancelDidCancel(_ textFieldWithCancel: TextFieldWithCancel) {}
    
    func textFieldWithCancel(_ textFieldWithCancel: UITextField, didReturnWith text: String) {
        let item = Item.toBuy(name: text)
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
        
        Repository.shared.add(item)
        
        refreshScene()
        
        textFieldWithCancel.resignFirstResponder()
        textFieldWithCancel.text = ""
    }
    
    func getCategoryIndex(item: Item) -> Int {
        return categories.index { $0 == item.category } ?? 0
    }
}
