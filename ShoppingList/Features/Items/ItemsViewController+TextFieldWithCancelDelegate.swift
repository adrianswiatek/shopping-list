import UIKit

extension ItemsViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancelDidCancel(_ textFieldWithCancel: UITextField) {}
    
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
        
        let categoryNameIndex = getCategoryIndex(item: item)
        items[categoryNameIndex].insert(item, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: categoryNameIndex)], with: .automatic)
        Repository.shared.add(item)
        
        refreshScene()
        
        textFieldWithCancel.resignFirstResponder()
        textFieldWithCancel.text = ""
    }
    
    func getCategoryIndex(item: Item) -> Int {
        return categories.index { $0 == item.category } ?? 0
    }
}
