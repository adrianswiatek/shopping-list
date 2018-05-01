import UIKit

extension ItemsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return false }
        
        Repository.addNew(item: Item.toBuy(name: text))
        tableView.insertRow(at: 0)
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
