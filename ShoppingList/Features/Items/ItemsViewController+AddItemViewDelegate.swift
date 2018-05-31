import UIKit

extension ItemsViewController: AddItemViewDelegate {
    func addItemTextField(_ addItemTextField: UITextField, didReturnWith text: String) {
        let item = Item.toBuy(name: text)
        
        if !categoryNames.contains(item.getCategoryName()) {
            categoryNames.append(item.getCategoryName())
            categoryNames.sort()
            
            let categoryNameIndex = getCategoryNameIndex(item: item)
            items.insert([Item](), at: categoryNameIndex)
            tableView.insertSections(IndexSet(integer: categoryNameIndex), with: .automatic)
        }
        
        let categoryNameIndex = getCategoryNameIndex(item: item)
        items[categoryNameIndex].insert(item, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: categoryNameIndex)], with: .automatic)
        Repository.shared.add(item)
        
        refreshScene()
        
        addItemTextField.resignFirstResponder()
        addItemTextField.text = ""
    }
    
    func getCategoryNameIndex(item: Item) -> Int {
        return categoryNames.index { $0 == item.getCategoryName() } ?? 0
    }
}
