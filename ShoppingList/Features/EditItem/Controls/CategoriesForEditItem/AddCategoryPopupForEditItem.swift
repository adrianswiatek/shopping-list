import UIKit

class AddCategoryPopupForEditItem {
 
    private let viewController: UIViewController
    private let completed: (String) -> ()
    
    private let alertController: UIAlertController
    
    init(viewController: UIViewController, completed: @escaping (String) -> ()) {
        self.viewController = viewController
        self.completed = completed
        self.alertController = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter category name..."
            textField.clearButtonMode = .whileEditing
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            let categoryName = self.alertController.textFields?[0].text ?? ""
            self.completed(categoryName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
    }
    
    func show() {
        alertController.textFields?[0].text = ""
        viewController.present(alertController, animated: true)
    }
}
