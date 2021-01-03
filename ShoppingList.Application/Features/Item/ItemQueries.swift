import ShoppingList_Domain

public protocol ItemQueries {
    func fetchItemsFromList(with id: Id<List>) -> [Item]
    func hasItemsInBasketOfList(with id: Id<List>) -> Bool
}
