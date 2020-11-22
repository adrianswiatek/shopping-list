import ShoppingList_Domain
import UIKit

public final class AddCategoryPopupForEditItem {
    private let viewController: UIViewController
    private let getCategories: () -> [ItemsCategory]
    private let completed: (String) -> ()
    
    public init(
        _ viewController: UIViewController,
        _ getCategories: @escaping () -> [ItemsCategory],
        completed: @escaping (String) -> ()
    ) {
        self.viewController = viewController
        self.getCategories = getCategories
        self.completed = completed
    }
    
    public func show() {
        let controller = PopupWithTextFieldController()
        controller.modalPresentationStyle = .overFullScreen
        controller.popupTitle = "Add Category"
        controller.placeholder = "Enter category name..."
        controller.saved = completed
        controller.set(getValidationButtonRule())
        viewController.present(controller, animated: true)
    }
    
    private func getValidationButtonRule() -> ValidationButtonRule {
        let notEmptyRule = ValidationButtonRuleLeaf.getNotEmptyCategoryRule()
        let uniqueRule = ValidationButtonRuleLeaf(
            message: "Category with given name already exists.",
            predicate: { [unowned self] text in self.getCategories().allSatisfy { $0.name != text } }
        )
        return ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule)
    }
}
