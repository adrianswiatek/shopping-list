import ShoppingList_Application
import ShoppingList_Domain
import CoreData

public final class CoreDataListRepository: ListRepository {
    private let coreData: CoreDataStack

    public init(_ coreData: CoreDataStack) {
        self.coreData = coreData
    }

    public func allLists() -> [List] {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        return (try? coreData.context.fetch(request).map { $0.toList() }) ?? []
    }

    public func list(with id: Id<List>) -> List? {
        listEntity(with: id)?.toList()
    }

    public func add(_ list: List) {
        let entity = ListEntity(context: coreData.context)
        entity.id = list.id.toUuid()
        entity.name = list.name
        entity.accessType = Int32(list.accessType.rawValue)
        entity.updateDate = list.updateDate

        let itemEntities = self.itemEntities(by: list.items.map { $0.id })
        entity.items = NSSet(array: itemEntities)

        coreData.context.insert(entity)
        coreData.save()
    }

    public func update(_ list: List) {
        guard let entity = listEntity(with: list.id) else { return }
        entity.update(by: list, context: coreData.context)
        coreData.save()
    }

    public func remove(by id: Id<List>) {
        guard let listEntity = listEntity(with: id) else { return }
        coreData.context.delete(listEntity)

//        if let orderEntity = itemsOrderEntity(with: id) {
//            coreData.context.delete(orderEntity)
//        }

        coreData.save()
    }

    private func listEntity(with id: Id<List>) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? coreData.context.fetch(request).first
    }

    private func itemsOrderEntity(with id: UUID) -> ItemsOrderEntity? {
        let request: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "listId == %@", id as CVarArg)
        return try? coreData.context.fetch(request).first
    }

    private func itemEntities(by ids: [Id<Item>]) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id in %@", ids.map { $0.toString() })
        return (try? coreData.context.fetch(request)) ?? []
    }
}
