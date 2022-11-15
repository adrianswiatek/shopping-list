import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_Shared
import CoreData

public final class CoreDataModelItemRepository: ModelItemRepository {
    private let coreData: CoreDataStack

    public init(_ coreData: CoreDataStack) {
        self.coreData = coreData
    }

    public func allItems() -> [ModelItem] {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }

    public func itemsWithNames(_ names: [String]) -> [ModelItem] {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name IN %@", names)
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }

    public func add(_ items: [ModelItem]) {
        if let item = items.first {
            add(item)
            add(items.tail())
        }
    }

    public func add(_ item: ModelItem) {
        guard let categoryEntity = categoryEntityWithId(item.categoryId) else {
            return assertionFailure("Category not found in the database")
        }

        let entity = ModelItemEntity(context: coreData.context)
        entity.id = item.id.toUuid()
        entity.name = item.name
        entity.category = categoryEntity

        coreData.context.insert(entity)
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

    private func categoryEntityWithId(_ id: Id<ItemsCategory>) -> CategoryEntity? {
        let categoryEntitiesRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoryEntitiesRequest.predicate = NSPredicate(format: "id == %@", id.toString())
        let categoryEntities = try? coreData.context.fetch(categoryEntitiesRequest)
        return categoryEntities?.first
    }
}
