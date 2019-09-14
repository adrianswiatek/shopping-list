import UIKit

struct WarningAlertBuilder {
    private let message: String
    private let buttonText: String
    
    init(message: String, buttonText: String) {
        self.message = message
        self.buttonText = buttonText
    }
    
    func build() -> UIAlertController {
        let alertController = createAlertController()
        addCancelAction(to: alertController)
        return alertController
    }
    
    private func createAlertController() -> UIAlertController {
        return UIAlertController(title: "", message: message, preferredStyle: .alert)
    }
    
    private func addCancelAction(to alertController: UIAlertController) {
        alertController.addAction(UIAlertAction(title: buttonText, style: .cancel))
    }
}
