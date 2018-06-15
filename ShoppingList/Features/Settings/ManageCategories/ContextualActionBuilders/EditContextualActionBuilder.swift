import UIKit

struct EditContextualActionBuilder {
    
    private let viewController: UIViewController
    private let category: Category
    private let saved: (String) -> ()
    
    init(viewController: UIViewController, category: Category, saved: @escaping (String) -> ()) {
        self.viewController = viewController
        self.category = category
        self.saved = saved
    }
    
    func build() -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit", handler: handler)
        action.backgroundColor = category.isDefault() ? #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1) : #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        action.image = #imageLiteral(resourceName: "Edit")
        return action
    }
    
    private func handler(
        action: UIContextualAction,
        sourceView: UIView,
        completionHandler: @escaping (Bool) -> Void) {
        category.isDefault()
            ? self.showEditWarningAlert { completionHandler(false) }
            : self.showEditAlert(
                saved: { self.saved($0); completionHandler(true) },
                cancelled: { completionHandler(false) })
    }
    
    private func showEditWarningAlert(dismissed: @escaping () -> ()) {
        let builder = WarningAlertBuilder(
            message: "You can not edit default category.",
            buttonText: "OK")
        viewController.present(builder.build(), animated: true) { dismissed() }
    }
    
    private func showEditAlert(
        saved: @escaping (String) -> (),
        cancelled: @escaping () -> ()) {
        var builder = EditCategoryAlertBuilder(categoryName: category.name)
        builder.saveButtonTapped = saved
        builder.cancelButtonTapped = cancelled
        viewController.present(builder.build(), animated: true)
    }
}
