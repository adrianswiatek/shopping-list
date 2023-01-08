import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_Shared
import CoreData

public final class CoreDataModelItemRepository: ModelItemRepository {
    private let coreData: CoreDataStack

    public init(_ coreData: CoreDataStack) {
        self.coreData = coreData
    }

    public func allModelItems() -> [ModelItem] {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }

    public func modelItemsWithNames(_ names: [String]) -> [ModelItem] {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name IN %@", names)
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }

    public func modelItemsInCategoryWithId(_ id: Id<ItemsCategory>) -> [ModelItem] {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category.id == %@", id.toString())
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }

    public func modelItemWithId(_ id: Id<ModelItem>) -> ModelItem? {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? coreData.context.fetch(request).first.map { $0.map() }
    }

    public func add(_ modelItems: [ModelItem]) {
        if let item = modelItems.first {
            add(item)
            add(modelItems.tail())
        }
    }

    public func add(_ modelItem: ModelItem) {
        guard let categoryEntity = categoryEntityWithId(modelItem.categoryId) else {
            return assertionFailure("Category not found in the database")
        }

        let entity = ModelItemEntity(context: coreData.context)
        entity.id = modelItem.id.toUuid()
        entity.name = modelItem.name
        entity.category = categoryEntity

        coreData.context.insert(entity)
        coreData.save()
    }

    public func update(_ modelItem: ModelItem) {
        guard let entity = modelItemEntityWithId(modelItem.id) else { return }
        entity.update(by: modelItem, context: coreData.context)
        coreData.save()
    }

    public func updateCategoryOfModelItemsWithIds(
        _ modelItemIds: [Id<ModelItem>],
        toCategory categoryId: Id<ItemsCategory>
    ) {
        let categoryEntity = categoryEntityWithId(categoryId)

        for modelItemEntity in modelItemEntitiesWithIds(modelItemIds) {
            modelItemEntity.category = categoryEntity
        }

        coreData.save()
    }

    public func remove(by id: Id<ModelItem>) {
        guard let entity = modelItemEntityWithId(id) else { return }
        coreData.context.delete(entity)
        coreData.save()
    }

    private func modelItemEntityWithId(_ id: Id<ModelItem>) -> ModelItemEntity? {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? coreData.context.fetch(request).first
    }

    private func modelItemEntitiesWithIds(_ ids: [Id<ModelItem>]) -> [ModelItemEntity] {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids.map { $0.toString() })
        return (try? coreData.context.fetch(request)) ?? []
    }

    private func categoryEntityWithId(_ id: Id<ItemsCategory>) -> CategoryEntity? {
        let categoryEntitiesRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoryEntitiesRequest.predicate = NSPredicate(format: "id == %@", id.toString())
        let categoryEntities = try? coreData.context.fetch(categoryEntitiesRequest)
        return categoryEntities?.first
    }
}
