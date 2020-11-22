import UIKit

public struct WarningAlertBuilder {
    private let message: String
    private let buttonText: String
    
    public init(message: String, buttonText: String) {
        self.message = message
        self.buttonText = buttonText
    }
    
    public func build() -> UIAlertController {
        let alertController = createAlertController()
        addCancelAction(to: alertController)
        return alertController
    }
    
    private func createAlertController() -> UIAlertController {
        .init(title: "", message: message, preferredStyle: .alert)
    }
    
    private func addCancelAction(to alertController: UIAlertController) {
        alertController.addAction(UIAlertAction(title: buttonText, style: .cancel))
    }
}
