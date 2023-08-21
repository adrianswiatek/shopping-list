import ShoppingList_Domain

public protocol ModelItemQueries {
    func fetchModelItems() -> [ModelItem]
}
