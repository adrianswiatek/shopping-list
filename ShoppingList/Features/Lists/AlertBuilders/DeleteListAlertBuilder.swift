import UIKit

struct DeleteListAlertBuilder {
    
    var deleteButtonTapped: (() -> ())?
    var cancelButtonTapped: (() -> ())?
    
    func build() -> UIAlertController {
        let alertMessage = "There are items in the list, that have not been bought yet. If continue, all list items will be deleted."
        let controller = UIAlertController(title: "Delete list", message: alertMessage, preferredStyle: .alert)
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.cancelButtonTapped?()
        }
        
        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteButtonTapped?()
        }
        
        controller.addAction(cancelAlertAction)
        controller.addAction(deleteAlertAction)
        
        return controller
    }
}
