extension EditItemViewController: ListsForEditItemDelegate {
    func listsForEditItemDidShowAddCategoryPopup(_ categoriesForEditItem: ListsForEditItem) {
        itemNameView.resignFirstResponder()
    }
}
