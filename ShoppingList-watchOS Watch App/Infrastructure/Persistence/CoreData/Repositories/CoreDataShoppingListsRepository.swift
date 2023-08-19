import CoreData

final class CoreDataShoppingListsRepository: ShoppingListsRepository {
    private let persistenceContainer: NSPersistentContainer

    init(persistenceContainer: NSPersistentContainer) {
        self.persistenceContainer = persistenceContainer
    }

    func add(_ list: ShoppingList) async {
        await persistenceContainer.performBackgroundTask { context in
            let entity = list.toEntity(context)
            context.insert(entity)
            try? context.save()
        }
    }

    func delete(_ listId: Id<ShoppingList>) async {
        await persistenceContainer.performBackgroundTask { [weak self] context in
            let entity = self?.findEntity(listId, inContext: context)

            guard let entity else { return }

            context.delete(entity)
            try? context.save()
        }
    }

    func fetchAll() async -> [ShoppingList] {
        await persistenceContainer.performBackgroundTask { context in
            let request: NSFetchRequest<ShoppingListEntity> = ShoppingListEntity.fetchRequest()
            let entities = try? context.fetch(request)
            return entities?.map { $0.toList() } ?? []
        }
    }

    func find(_ listId: Id<ShoppingList>) async -> ShoppingList? {
        await persistenceContainer.performBackgroundTask { [weak self] context in
            self?.findEntity(listId, inContext: context).map { $0.toList() }
        }
    }

    func update(_ list: ShoppingList) async {
        await persistenceContainer.performBackgroundTask { [weak self] context in
            let entity = self?.findEntity(list.id, inContext: context)
            entity?.updateWithList(list)
            try? context.save()
        }
    }

    private func findEntity(
        _ listId: Id<ShoppingList>,
        inContext context: NSManagedObjectContext
    ) -> ShoppingListEntity? {
        let request: NSFetchRequest<ShoppingListEntity> = ShoppingListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", listId.asString())
        return try? context.fetch(request).first
    }
}
