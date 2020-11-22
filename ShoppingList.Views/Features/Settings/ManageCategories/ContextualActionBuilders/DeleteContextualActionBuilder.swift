import ShoppingList_Domain
import UIKit

public struct DeleteContextualActionBuilder {
    private let viewController: ManageCategoriesViewController
    private let category: ItemsCategory
    private let isCategoryEmpty: Bool
    private let deleteCategory: () -> ()
    private let deletedCategoryWithItems: () -> ()
    
    public init(
        viewController: ManageCategoriesViewController,
        category: ItemsCategory,
        isCategoryEmpty: Bool,
        deleteCategory: @escaping () -> (),
        deletedCategoryWithItems: @escaping () -> ()
    ) {
        self.viewController = viewController
        self.category = category
        self.isCategoryEmpty = isCategoryEmpty
        self.deleteCategory = deleteCategory
        self.deletedCategoryWithItems = deletedCategoryWithItems
    }
    
    func build() -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil, handler: handler)
        action.backgroundColor = category.isDefault ? #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        action.image = #imageLiteral(resourceName: "Trash").withRenderingMode(.alwaysTemplate)
        return action
    }
    
    private func handler(
        action: UIContextualAction,
        sourceView: UIView,
        completionHandler: @escaping (Bool) -> Void
    ) {
        guard !category.isDefault else {
            return showDeleteWarningAction() { completionHandler(false) }
        }
        
        if isCategoryEmpty {
            // TODO: command
            // let command = RemoveCategoryCommand(category, viewController)
            // CommandInvoker.shared.execute(command)
            completionHandler(true)
            return
        }
        
        self.showDeleteAlert(
            deleted: {
                self.deleteCategory()
                self.deletedCategoryWithItems()
                completionHandler(true)
            },
            cancelled: { completionHandler(false) })
    }
    
    private func showDeleteWarningAction(dismissed: @escaping () -> ()) {
        let builder = WarningAlertBuilder(
            message: "You cannot delete default category.",
            buttonText: "OK"
        )
        viewController.present(builder.build(), animated: true) { dismissed() }
    }
    
    private func showDeleteAlert(deleted: @escaping () -> (), cancelled: @escaping () -> ()) {
        var builder = DeleteCategoryAlertBuilder()
        builder.deleteButtonTapped = deleted
        builder.cancelButtonTapped = cancelled
        viewController.present(builder.build(), animated: true)
    }
}
