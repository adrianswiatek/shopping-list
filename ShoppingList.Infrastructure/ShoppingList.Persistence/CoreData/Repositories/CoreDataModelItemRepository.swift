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
        let entity = ModelItemEntity(context: coreData.context)
        entity.id = item.id.toUuid()
        entity.name = item.name

        coreData.context.insert(entity)
        coreData.save()
    }

    public func remove(by id: Id<ModelItem>) {
//        guard let entity = modelItemEntity(with: id) else { return }
//        coreData.context.delete(entity)
//        coreData.save()
    }

//    public func category(with id: Id<ItemsCategory>) -> ItemsCategory? {
//        modelItemEntity(with: id)?.map()
//    }

//    private func modelItemEntity(with id: Id<ItemsCategory>) -> ModelItemEntity? {
//        let request: NSFetchRequest<ModelItemEntity> = ModelItemEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id.toString())
//        return try? coreData.context.fetch(request).first
//    }
}
