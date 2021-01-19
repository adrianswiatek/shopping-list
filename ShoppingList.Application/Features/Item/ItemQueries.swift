import ShoppingList_Domain

public protocol ItemQueries {
    func fetchItemsToBuyFromList(with id: Id<List>) -> [Item]
    func fetchItemsInBasketFromList(with id: Id<List>) -> [Item]
    func fetchItemsInCategory(_ category: ItemsCategory) -> [Item]
    func hasItemsInBasketOfList(with id: Id<List>) -> Bool
}
