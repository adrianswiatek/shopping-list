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

        let itemIds = list.items.map { $0.id }
        let itemEntities = self.itemEntities(by: itemIds)
        entity.items = NSSet(array: itemEntities)

        let itemsOrderEntity = ItemsOrderEntity(context: coreData.context)
        itemsOrderEntity.listId = list.id.toUuid()
        itemsOrderEntity.itemsState = Int32(ItemState.toBuy.rawValue)

        let itemIdsData = try? JSONEncoder().encode(itemIds.map { $0.toUuid() })
        itemsOrderEntity.itemsIds = itemIdsData ?? Data()

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

        if let orderEntity = itemsOrderEntity(with: id) {
            coreData.context.delete(orderEntity)
        }

        coreData.save()
    }

    private func listEntity(with listId: Id<List>) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", listId.toString())
        return try? coreData.context.fetch(request).first
    }

    private func itemsOrderEntity(with listId: Id<List>) -> ItemsOrderEntity? {
        let request: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "listId == %@", listId.toString())
        return try? coreData.context.fetch(request).first
    }

    private func itemEntities(by itemIds: [Id<Item>]) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id in %@", itemIds.map { $0.toString() })
        return (try? coreData.context.fetch(request)) ?? []
    }
}
