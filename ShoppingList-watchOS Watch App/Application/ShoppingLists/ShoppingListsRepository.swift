protocol ShoppingListsRepository {
    func add(_ list: ShoppingList) async
    func delete(_ listId: Id<ShoppingList>) async
    func fetchAll() async -> [ShoppingList]
    func find(_ listId: Id<ShoppingList>) async -> ShoppingList?
    func update(_ list: ShoppingList) async
}
        
