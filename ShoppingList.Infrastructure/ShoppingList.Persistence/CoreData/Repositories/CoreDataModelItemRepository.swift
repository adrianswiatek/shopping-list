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

    public func modelItemWithId(_ id: Id<ModelItem>) -> ModelItem? {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? coreData.context.fetch(request).first.map { $0.map() }
    }

    public func modelItemWithName(_ name: String) -> ModelItem? {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        return try? coreData.context.fetch(request).first.map { $0.map() }
    }

    public func modelItemsWithNames(_ names: [String]) -> [ModelItem] {
        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name IN %@", names)
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }

    public func add(_ modelItems: [ModelItem]) {
        if let item = modelItems.first {
            add(item)
            add(modelItems.tail())
        }
    }

    public func add(_ modelItem: ModelItem) {
        let entity = ModelItemEntity(context: coreData.context)
        entity.id = modelItem.id.toUuid()
        entity.name = modelItem.name

        coreData.context.insert(entity)
        coreData.save()
    }

    public func update(_ modelItem: ModelItem) {
        guard let entity = modelItemEntityWithId(modelItem.id) else { return }
        entity.update(by: modelItem, context: coreData.context)
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
}
