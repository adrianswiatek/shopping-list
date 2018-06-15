import UIKit

struct DeleteCategoryAlertBuilder {
    
    var deleteButtonTapped: (() -> ())?
    var cancelButtonTapped: (() -> ())?
    
    func build() -> UIAlertController {
        let alertMessage = "There are items related with this category. If continue, all category items will be swapped to default category."
        let controller = UIAlertController(title: "Delete category", message: alertMessage, preferredStyle: .alert)
        
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
