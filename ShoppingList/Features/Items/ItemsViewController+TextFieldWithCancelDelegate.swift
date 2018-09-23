import UIKit

extension ItemsViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let item = Item.toBuy(name: text, info: "", list: currentList)
        
        if !categories.containsDefaultCategory() {
            append(Category.getDefault())
        }
        
        let categoryIndex = getCategoryIndex(item)
        items[categoryIndex].insert(item, at: 0)
        
        let indexPath = IndexPath(row: 0, section: categoryIndex)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        Repository.shared.add(item)
        
        refreshUserInterface()
    }
}
