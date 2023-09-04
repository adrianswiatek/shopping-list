import ShoppingList_Domain

public protocol ModelItemRepository {
    func allModelItems() -> [ModelItem]
    func modelItemWithId(_ id: Id<ModelItem>) -> ModelItem?
    func modelItemWithName(_ name: String) -> ModelItem?
    func modelItemsWithNames(_ names: [String]) -> [ModelItem]

    func add(_ modelItem: ModelItem)
    func add(_ modelItems: [ModelItem])

    func update(_ modelItem: ModelItem)

    func remove(by id: Id<ModelItem>)
}
