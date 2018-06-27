import UIKit

struct EditListAlertBuilder {
    
    var saveButtonTapped: ((String) -> ())?
    var cancelButtonTapped: (() -> ())?
    
    private let listName: String
    
    init(listName: String) {
        self.listName = listName
    }
    
    func build() -> UIAlertController {
        let alertController = createAlertController()
        addTextField(to: alertController)
        addSaveAction(to: alertController)
        addCancelAction(to: alertController)
        return alertController
    }
    
    private func createAlertController() -> UIAlertController {
        return UIAlertController(title: "Edit list", message: nil, preferredStyle: .alert)
    }
    
    private func addTextField(to alertController: UIAlertController) {
        alertController.addTextField { textField in
            textField.text = self.listName
            textField.clearButtonMode = .whileEditing
        }
    }
    
    private func addSaveAction(to alertController: UIAlertController) {
        let action = UIAlertAction(title: "Save", style: .default) { _ in
            self.saveButtonTapped?(alertController.textFields?[0].text ?? "")
        }
        alertController.addAction(action)
    }
    
    private func addCancelAction(to alertController: UIAlertController) {
        let action = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.cancelButtonTapped?()
        }
        alertController.addAction(action)
    }
}
