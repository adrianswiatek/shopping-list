import CoreData

extension ShoppingItemEntity {
    func toItem() -> ShoppingItem {
        guard
            let id = id.map(Id<ShoppingItem>.fromUuid),
            let listId = listId.map(Id<ShoppingList>.fromUuid),
            let name = name,
            let category = category,
            let state = state.flatMap(ShoppingItem.State.init),
            let lastChange = lastChange
        else {
            fatalError("Unable to create ShoppingItem")
        }

        return ShoppingItem(id, listId, name, category, state, lastChange)
    }

    func updateWithItem(_ item: ShoppingItem) {
        listId = item.listId.asUuid()
        name = item.name
        category = item.category
        state = item.state.rawValue
        lastChange = item.lastChange
    }
}

extension ShoppingItem {
    func toEntity(_ context: NSManagedObjectContext) -> ShoppingItemEntity {
        let entity = ShoppingItemEntity(context: context)
        entity.id = id.asUuid()
        entity.listId = listId.asUuid()
        entity.name = name
        entity.category = category
        entity.state = state.rawValue
        entity.lastChange = lastChange
        return entity
    }
}
