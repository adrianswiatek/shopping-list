import UIKit

class BasketToolbarController: NSObject {
    
    private let regularToolbar: BasketToolbarRegular
    private let editToolbar: BasketToolbarEdit
    
    init(_ regularToolbar: BasketToolbarRegular, _ editToolbar: BasketToolbarEdit) {
        self.regularToolbar = regularToolbar
        self.editToolbar = editToolbar
    }
    
    func showRegularToolbar() {
        regularToolbar.toolbar.alpha = 1
        editToolbar.toolbar.alpha = 0
    }
    
    func setRegularToolbarButtonsAsEditable() {
        regularToolbar.actionButton.isEnabled = true
        regularToolbar.editButton.isEnabled = true
    }
    
    func setRegularToolbarButtonsAsNotEditable() {
        regularToolbar.actionButton.isEnabled = false
        regularToolbar.editButton.isEnabled = false
    }
    
    func showEditToolbar() {
        regularToolbar.toolbar.alpha = 0
        editToolbar.toolbar.alpha = 1
    }
    
    func setEditToolbarButtonsAsEditable() {
        editToolbar.deleteButton.isEnabled = true
        editToolbar.restoreButton.isEnabled = true
    }
    
    func setEditToolbarButtonsAsNotEditable() {
        editToolbar.deleteButton.isEnabled = false
        editToolbar.restoreButton.isEnabled = false
    }
}
