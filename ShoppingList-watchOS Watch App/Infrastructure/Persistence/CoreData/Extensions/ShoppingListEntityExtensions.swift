import CoreData

extension ShoppingListEntity {
    func toList() -> ShoppingList {
        guard let id = id, let name = name else {
            fatalError("Unable to create ShoppingList")
        }
        return ShoppingList(id: .fromUuid(id), name: name, visited: visited)
    }

    func updateWithList(_ list: ShoppingList) {
        name = list.name
        visited = list.visited
    }
}

extension ShoppingList {
    func toEntity(_ context: NSManagedObjectContext) -> ShoppingListEntity {
        let entity = ShoppingListEntity(context: context)
        entity.id = id.asUuid()
        entity.name = name
        entity.visited = visited
        return entity
    }
}
