import UIKit

struct EditContextualActionBuilder {
    
    private let viewController: UIViewController
    private let category: Category
    private let saved: (String) -> Void
    private let savedDefault: (String) -> Void
    
    init(
        viewController: UIViewController,
        category: Category,
        saved: @escaping (String) -> Void,
        savedDefault: @escaping (String) -> Void) {
        self.viewController = viewController
        self.category = category
        self.saved = saved
        self.savedDefault = savedDefault
    }
    
    func build() -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit", handler: handler)
        action.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        action.image = #imageLiteral(resourceName: "Edit")
        return action
    }
    
    private func handler(
        action: UIContextualAction,
        sourceView: UIView,
        completionHandler: @escaping (Bool) -> Void) {
        self.showEditAlert(
            saved: {
                self.category.isDefault() ? self.savedDefault($0) : self.saved($0)
                completionHandler(true)
            },
            cancelled: {
                completionHandler(false)
            })
    }
    
    private func showEditAlert(
        saved: @escaping (String) -> Void,
        cancelled: @escaping () -> Void) {
        var builder = EditCategoryAlertBuilder(categoryName: category.name)
        builder.saveButtonTapped = saved
        builder.cancelButtonTapped = cancelled
        viewController.present(builder.build(), animated: true)
    }
}
