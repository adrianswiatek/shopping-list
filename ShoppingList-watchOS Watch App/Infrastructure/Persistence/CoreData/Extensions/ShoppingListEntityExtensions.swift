import CoreData

extension ShoppingListEntity {
    func toList() -> ShoppingList {
        guard let id = id, let name = name else {
            fatalError("Unable to create ShoppingList")
        }
        return ShoppingList(.fromUuid(id), name)
    }

    func updateWithList(_ list: ShoppingList) {
        name = list.name
    }
}

extension ShoppingList {
    func toEntity(_ context: NSManagedObjectContext) -> ShoppingListEntity {
        let entity = ShoppingListEntity(context: context)
        entity.id = id.asUuid()
        entity.name = name
        return entity
    }
}
