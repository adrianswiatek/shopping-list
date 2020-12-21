import ShoppingList_Domain
import UIKit

public struct EditContextualActionBuilder {
    private let viewController: UIViewController
    private let category: ItemsCategory
    private let categories: [ItemsCategory]
    private let saved: (String) -> Void
    private let savedDefault: (String) -> Void
    
    public init(
        viewController: UIViewController,
        category: ItemsCategory,
        categories: [ItemsCategory],
        saved: @escaping (String) -> Void,
        savedDefault: @escaping (String) -> Void
    ) {
        self.viewController = viewController
        self.category = category
        self.categories = categories
        self.saved = saved
        self.savedDefault = savedDefault
    }
    
    public func build() -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil, handler: handler)
        action.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        action.image = #imageLiteral(resourceName: "Edit").withRenderingMode(.alwaysTemplate)
        return action
    }
    
    private func handler(
        action: UIContextualAction,
        sourceView: UIView,
        completionHandler: @escaping (Bool) -> Void
    ) {
        self.showEditPopup(
            saved: {
                self.category.isDefault ? self.savedDefault($0) : self.saved($0)
                completionHandler(true)
            },
            cancelled: {
                completionHandler(false)
            })
    }

    private func showEditPopup(saved: @escaping (String) -> Void, cancelled: @escaping () -> Void) {
        let controller = PopupWithTextFieldController()
        controller.modalPresentationStyle = .overFullScreen
        controller.popupTitle = "Edit Category"
        controller.placeholder = "Enter category name..."
        controller.text = category.name
        controller.saved = saved
        controller.cancelled = cancelled
        controller.set(validationButtonRule())
        viewController.present(controller, animated: true)
    }
    
    private func validationButtonRule() -> ValidationButtonRule {
        let notEmptyRule = ValidationButtonRuleLeaf.notEmptyCategoryRule
        let uniqueRule = ValidationButtonRuleLeaf(
            message: "Category with given name already exists.",
            predicate: { text in self.categories.allSatisfy { $0.name != text } || text == self.category.name }
        )
        return ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule)
    }
}
