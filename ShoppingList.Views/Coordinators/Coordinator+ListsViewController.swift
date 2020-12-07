import UIKit

extension Coordinator: ListsViewControllerDelegate {
    public func goToSettings() {
        let settings = UINavigationController(rootViewController: SettingsViewController())
        rootViewController.present(settings, animated: true)
    }

    public func showEditPopupForList(with name: String, completion: @escaping (String) -> Void) {
        let controller = PopupWithTextFieldController()
        controller.modalPresentationStyle = .overFullScreen
        controller.popupTitle = "Edit list name"
        controller.placeholder = "Enter list name..."
        controller.text = name
        controller.saved = completion
        rootViewController.present(controller, animated: true)
    }

    public func showRemoveListWarning(onAccepted: @escaping () -> Void) {
        let alertMessage = "There are items in the list, that have not been bought yet. If continue, all list items will be removed."

        let controller = UIAlertController(
            title: "Remove list",
            message: alertMessage,
            preferredStyle: .actionSheet
        )

        controller.addAction(.init(title: "Cancel", style: .cancel))
        controller.addAction(.init(title: "Remove permanently", style: .destructive) { _ in onAccepted()
        })

        rootViewController.present(controller, animated: true)
    }

    public func showValidationError(with text: String) {
        let controller = UIAlertController(title: "", message: text, preferredStyle: .alert)
        controller.addAction(.init(title: "OK", style: .default))
        rootViewController.present(controller, animated: true)
    }
}
