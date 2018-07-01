import UIKit

class AddListPopupForEditItem {
    
    private let viewController: UIViewController
    private let completed: (String) -> ()
    
    private let alertController: UIAlertController
    
    init(_ viewController: UIViewController, completed: @escaping (String) -> ()) {
        self.viewController = viewController
        self.completed = completed
        self.alertController = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter list name..."
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
