import UIKit

extension EditItemViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addCategoryTextFieldAnimations.hide()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
