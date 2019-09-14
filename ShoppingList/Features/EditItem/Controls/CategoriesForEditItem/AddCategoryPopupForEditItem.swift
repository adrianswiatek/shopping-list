import UIKit

final class AddCategoryPopupForEditItem {
    private let viewController: UIViewController
    private let getCategories: () -> [Category]
    private let completed: (String) -> ()
    
    init(
        _ viewController: UIViewController,
        _ getCategories: @escaping () -> [Category],
        completed: @escaping (String) -> ()) {
        self.viewController = viewController
        self.getCategories = getCategories
        self.completed = completed
    }
    
    func show() {
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
            predicate: { [unowned self] text in self.getCategories().allSatisfy { $0.name != text } })
        
        return ValidationButtonRuleComposite(rules: notEmptyRule, uniqueRule)
    }
}
