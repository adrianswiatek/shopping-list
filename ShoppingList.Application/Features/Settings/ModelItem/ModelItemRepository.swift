import ShoppingList_Domain

public protocol ModelItemRepository {
    func allModelItems() -> [ModelItem]
    func modelItemsWithNames(_ names: [String]) -> [ModelItem]
    func modelItemsInCategoryWithId(_ id: Id<ItemsCategory>) -> [ModelItem]
    func modelItemWithId(_ id: Id<ModelItem>) -> ModelItem?

    func add(_ modelItem: ModelItem)
    func add(_ modelItems: [ModelItem])

    func update(_ modelItem: ModelItem)
    func updateCategoryOfModelItemsWithIds(
        _ modelItemIds: [Id<ModelItem>],
        toCategory categoryId: Id<ItemsCategory>
    )


    func remove(by id: Id<ModelItem>)
}
