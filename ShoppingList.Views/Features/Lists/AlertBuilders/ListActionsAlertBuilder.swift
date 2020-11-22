import ShoppingList_Domain
import UIKit

public struct ListActionsAlertBuilder {
    public var delegate: ListsActionsAlertDelegate?
    
    private let list: List
    
    init(_ list: List) {
        self.list = list
    }
    
    public func build() -> UIAlertController {
        anyItemsExist() ? buildListsActionsAlertController() : buildEmptyListsActionsAlertController()
    }
    
    private func anyItemsExist() -> Bool {
        list.numberOfItemsToBuy() > 0 || list.numberOfItemsInBasket() > 0
    }
    
    private func buildListsActionsAlertController() -> UIAlertController {
        let alertController = createAlertController()
        addDeleteAllItemsButton(to: alertController)
        addEmptyBasketButton(to: alertController)
        addCancelButton(to: alertController)
        return alertController
    }
    
    private func createAlertController() -> UIAlertController {
        return UIAlertController(title: nil, message: list.name, preferredStyle: .actionSheet)
    }
    
    private func addDeleteAllItemsButton(to alertController: UIAlertController) {
        guard list.numberOfItemsToBuy() > 0 else { return }
        
        let action = UIAlertAction(title: "Delete all items", style: .destructive) { _ in
            self.delegate?.deleteAllItemsIn(self.list)
        }
        
        alertController.addAction(action)
    }
    
    private func addEmptyBasketButton(to alertController: UIAlertController) {
        guard list.numberOfItemsInBasket() > 0 else { return }
        
        let action = UIAlertAction(title: "Empty the basket", style: .destructive) { _ in
            self.delegate?.emptyBasketIn(self.list)
        }
        
        alertController.addAction(action)
    }
    
    private func addCancelButton(to alertController: UIAlertController) {
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action)
    }
    
    private func buildEmptyListsActionsAlertController() -> UIAlertController {
        let alertController = UIAlertController(
            title: nil,
            message: "There are no items in the list",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        return alertController
    }
}
