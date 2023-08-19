protocol ShoppingItemsRepository {
    func add(_ items: [ShoppingItem]) async
    func fetch(_ listId: Id<ShoppingList>) async -> [ShoppingItem]
    func find(_ itemId: Id<ShoppingItem>) async -> ShoppingItem?

    func delete(_ itemIds: [Id<ShoppingItem>]) async
    func delete(_ listId: Id<ShoppingList>) async

    func update(_ item: ShoppingItem) async
}
