import UIKit

struct ListActionsAlertBuilder {
    var delegate: ListsActionsAlertDelegate?
    
    private let list: List
    
    init(_ list: List) {
        self.list = list
    }
    
    func build() -> UIAlertController {
        return anyItemsExist()
            ? buildListsActionsAlertController()
            : buildEmptyListsActionsAlertController()
    }
    
    private func anyItemsExist() -> Bool {
        return list.getNumberOfItemsToBuy() > 0 || list.getNumberOfItemsInBasket() > 0
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
        guard list.getNumberOfItemsToBuy() > 0 else { return }
        
        let action = UIAlertAction(title: "Delete all items", style: .destructive) { _ in
            self.delegate?.deleteAllItemsIn(self.list)
        }
        
        alertController.addAction(action)
    }
    
    private func addEmptyBasketButton(to alertController: UIAlertController) {
        guard list.getNumberOfItemsInBasket() > 0 else { return }
        
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
        let alertController = createEmptyAlertController()
        addOkButton(to: alertController)
        return alertController
    }
    
    private func createEmptyAlertController() -> UIAlertController {
        let alertMessage = "There are no items in the list"
        return UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
    }
    
    private func addOkButton(to alertController: UIAlertController) {
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
    }
}
