import UIKit

extension ItemsViewController: AddItemViewDelegate {
    func addItemTextField(_ addItemTextField: UITextField, didReturnWith text: String) {
        let item = Item.toBuy(name: text)
        items.insert(item, at: 0)
        tableView.insertRow(at: 0)
        
        Repository.shared.add(item)
        
        refreshScene()
        
        addItemTextField.resignFirstResponder()
        addItemTextField.text = ""
    }
}
