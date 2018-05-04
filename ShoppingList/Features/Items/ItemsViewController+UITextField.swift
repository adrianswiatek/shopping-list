import UIKit

extension ItemsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return false }
        
        let item = Item.toBuy(name: text)
        items.insert(item, at: 0)
        tableView.insertRow(at: 0)
        
        Repository.shared.add(item)
        
        refreshScene()
        
        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButtonAnimations.show()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButtonAnimations.hide()
    }
}
