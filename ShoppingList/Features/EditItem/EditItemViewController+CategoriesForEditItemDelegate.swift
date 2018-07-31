import UIKit

extension EditItemViewController: CategoriesForEditItemDelegate {
    func categoriesForEditItemDidShowAddCategoryPopup(_ categoriesForEditItem: CategoriesForEditItem) {
        itemNameView.resignFirstResponder()
    }
}
