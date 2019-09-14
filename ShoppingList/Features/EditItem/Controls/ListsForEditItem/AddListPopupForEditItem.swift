import UIKit

final class AddListPopupForEditItem {
    private let viewController: UIViewController
    private let completed: (String) -> ()
    
    init(_ viewController: UIViewController, completed: @escaping (String) -> ()) {
        self.viewController = viewController
        self.completed = completed
    }
    
    func show() {
        let controller = PopupWithTextFieldController()
        controller.modalPresentationStyle = .overFullScreen
        controller.popupTitle = "Add List"
        controller.placeholder = "Enter list name..."
        controller.saved = completed
        viewController.present(controller, animated: true)
    }
}
