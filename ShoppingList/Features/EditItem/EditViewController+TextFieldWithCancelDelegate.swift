import UIKit

extension EditItemViewController: TextFieldWithCancelDelegate {
    func textFieldWithCancel(_ textFieldWithCancel: TextFieldWithCancel, didReturnWith text: String) {
        let category = Category.new(name: text)
        categories.append(category)
        Repository.shared.add(category)

        categories.sort { $0.name < $1.name }
        categoriesPickerView.reloadComponent(0)
        
        if let newCategoryRow = categories.index(where: { $0.name == text }) {
            categoriesPickerView.selectRow(newCategoryRow, inComponent: 0, animated: true)
        }
        
        addCategoryTextFieldAnimations.hide()
    }
    
    func textFieldWithCancelDidCancel(_ textFieldWithCancel: TextFieldWithCancel) {
        addCategoryTextFieldAnimations.hide()
    }
}
