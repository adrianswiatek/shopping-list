import UIKit

extension EditItemViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancel(_ textFieldWithCancel: UITextField, didReturnWith text: String) {
        categories.append(text)
        categories.sort()
        categoriesPickerView.reloadComponent(0)
        
        if let newCategoryRow = categories.index(where: { $0 == text }) {
            categoriesPickerView.selectRow(newCategoryRow, inComponent: 0, animated: true)
        }
        
        addCategoryTextFieldAnimations.hide()
    }
    
    func textFieldWithCancelDidCancel(_ textFieldWithCancel: UITextField) {
        addCategoryTextFieldAnimations.hide()
    }
}
