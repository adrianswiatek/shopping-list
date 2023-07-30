import CoreData

final class CoreDataShoppingItemsRepository: ShoppingItemsRepository {
    private let persistenceContainer: NSPersistentContainer

    init(persistenceContainer: NSPersistentContainer) {
        self.persistenceContainer = persistenceContainer
    }

    func add(_ items: [ShoppingItem]) async {
        guard let listId = items.first?.listId else { return }

        await persistenceContainer.performBackgroundTask { [weak self] context in
            let listEntity = self?.findEntity(listId, inContext: context)
            for item in items {
                let itemEntity = item.toEntity(context)
                listEntity?.addToItems(itemEntity)
            }
            try? context.save()
        }
    }

    func fetch(_ listId: Id<ShoppingList>) async -> [ShoppingItem] {
        await persistenceContainer.performBackgroundTask { [weak self] context in
            self?.fetchEntities(listId, inContext: context).map { $0.toItem() } ?? []
        }
    }

    func find(_ itemId: Id<ShoppingItem>) async -> ShoppingItem? {
        await persistenceContainer.performBackgroundTask { [weak self] context in
            self?.findEntity(itemId, inContext: context).map { $0.toItem() }
        }
    }

    func delete(_ itemIds: [Id<ShoppingItem>]) async {
        await persistenceContainer.performBackgroundTask { [weak self] context in
            guard let self else { return }
            for entity in self.fetchEntities(itemIds, inContext: context) {
                context.delete(entity)
            }
            try? context.save()
        }
    }

    func delete(_ listId: Id<ShoppingList>) async {
        await persistenceContainer.performBackgroundTask { [weak self] context in
            guard let self else { return }
            for entity in self.fetchEntities(listId, inContext: context) {
                context.delete(entity)
            }
            try? context.save()
        }
    }

    func update(_ item: ShoppingItem) async {
        await persistenceContainer.performBackgroundTask { [weak self] context in
            let entity = self?.findEntity(item.id, inContext: context)
            entity?.updateWithItem(item)
            try? context.save()
        }
    }

    private func findEntity(
        _ itemId: Id<ShoppingItem>,
        inContext context: NSManagedObjectContext
    ) -> ShoppingItemEntity? {
        let request: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", itemId.asString())
        return try? context.fetch(request).first
    }

    private func findEntity(
        _ listId: Id<ShoppingList>,
        inContext context: NSManagedObjectContext
    ) -> ShoppingListEntity? {
        let request: NSFetchRequest<ShoppingListEntity> = ShoppingListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", listId.asString())
        return try? context.fetch(request).first
    }

    private func fetchEntities(
        _ itemIds: [Id<ShoppingItem>],
        inContext context: NSManagedObjectContext
    ) -> [ShoppingItemEntity] {
        let request: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", itemIds.map { $0.asString() })
        return (try? context.fetch(request)) ?? []
    }

    private func fetchEntities(
        _ listId: Id<ShoppingList>,
        inContext context: NSManagedObjectContext
    ) -> [ShoppingItemEntity] {
        let request: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "listId == %@", listId.asString())
        return (try? context.fetch(request)) ?? []
    }
}
