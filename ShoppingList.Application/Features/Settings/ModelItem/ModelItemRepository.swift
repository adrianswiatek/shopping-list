import ShoppingList_Domain

public protocol ModelItemRepository {
    func allItems() -> [ModelItem]
    func itemsWithNames(_ names: [String]) -> [ModelItem]
    func add(_ item: ModelItem)
    func add(_ items: [ModelItem])
    func remove(by id: Id<ModelItem>)
}
