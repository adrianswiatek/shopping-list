import ShoppingList_Domain

public protocol ListsActionsAlertDelegate {
    func deleteAllItemsIn(_ list: List)
    func emptyBasketIn(_ list: List)
}
