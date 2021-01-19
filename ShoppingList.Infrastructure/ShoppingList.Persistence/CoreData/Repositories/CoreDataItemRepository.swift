import ShoppingList_Application
import ShoppingList_Domain
import CoreData

public final class CoreDataItemRepository: ItemRepository {
    private let coreData: CoreDataStack

    public init(_ coreData: CoreDataStack) {
        self.coreData = coreData
    }

    public func item(with id: Id<Item>) -> Item? {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? coreData.context.fetch(request).first?.toItem()
    }
    
    public func itemsWithState(_ state: ItemState, inListWithId id: Id<List>) -> [Item] {
        let itemsRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        itemsRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "state == %@", state.rawValue.description),
            NSPredicate(format: "list.id == %@", id.toString())
        ])
        
        let itemsOrdersRequest: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        itemsOrdersRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "itemsState == %@", state.rawValue.description),
            NSPredicate(format: "listId == %@", id.toString())
        ])
        
        do {
            let itemsEntities = try coreData.context.fetch(itemsRequest)
            let unorderedItems = itemsEntities.map { $0.toItem() }
            var orderedItemsIds = [Id<Item>]()
            
            let itemsOrdersEntities = try coreData.context.fetch(itemsOrdersRequest)
            if let itemsOrderEntity = itemsOrdersEntities.first {
                let itemsOrder = itemsOrderEntity.map()
                orderedItemsIds = itemsOrder.itemsIds
            }
            
            return ItemsSorter.sort(unorderedItems, by: orderedItemsIds)
        } catch {
            fatalError("Unable to fetch Items: \(error)")
        }
    }

    public func itemsInCategory(_ category: ItemsCategory) -> [Item] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category.id == %@", category.id.toString())
        return (try? coreData.context.fetch(request).map { $0.toItem() }) ?? []
    }

    public func items(with ids: [Id<Item>]) -> [Item] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids.map { $0.toString() })
        return (try? coreData.context.fetch(request).map { $0.toItem() }) ?? []
    }

    public func numberOfItemsWith(state: ItemState, inListWithId id: Id<List>) -> Int {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "state == %@", state.rawValue.description),
            NSPredicate(format: "list.id == %@", id.toString())
        ])
        return (try? coreData.context.count(for: request)) ?? 0
    }
    
    public func numberOfItemsInList(with id: Id<List>) -> Int {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "list.id == $@", id.toString())
        return (try? coreData.context.count(for: request)) ?? 0
    }

    public func addItems(_ items: [Item]) {
        let listEntitiesRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        listEntitiesRequest.predicate = NSPredicate(format: "id IN %@", items.map { $0.listId.toString() })
        let listEntities = (try? coreData.context.fetch(listEntitiesRequest)) ?? []

        let categoryEntitiesRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoryEntitiesRequest.predicate = NSPredicate(format: "id IN %@", items.map { $0.categoryId.toString() })
        let categoryEntities = (try? coreData.context.fetch(categoryEntitiesRequest)) ?? []

        for item in items {
            let entity = ItemEntity(context: coreData.context)
            entity.id = item.id.toUuid()
            entity.name = item.name
            entity.info = item.info
            entity.state = Int32(item.state.rawValue)
            entity.list = listEntities.first { $0.id == item.listId.toUuid() }
            entity.category = categoryEntities.first { $0.id == item.categoryId.toUuid() }
            coreData.context.insert(entity)
        }

        coreData.save()
    }
    
    public func removeItems(with ids: [Id<Item>]) {
        let entities = itemEntities(with: ids)
        entities.forEach { coreData.context.delete($0) }
        coreData.save()
    }
    
    public func updateStateOfItems(with ids: [Id<Item>], to state: ItemState) {
        let entities = itemEntities(with: ids)
        entities.forEach { $0.state = Int32(state.rawValue) }
        coreData.save()
    }
    
    public func updateState(of item: Item, to state: ItemState) {
        guard let entity = itemEntity(with: item.id) else { return }
        entity.state = Int32(state.rawValue)
        coreData.save()
    }

    public func updateItem(_ item: Item) {
        guard let entity = itemEntity(with: item.id) else { return }
        entity.update(by: item, context: coreData.context)
        coreData.save()
    }
    
    public func updateCategory(of item: Item, to category: ItemsCategory) {
        guard let itemEntity = itemEntity(with: item.id) else { return }
        
        var categoryEntity: CategoryEntity?
        if !category.isDefault {
            categoryEntity = self.categoryEntity(from: category)
        }
        
        itemEntity.category = categoryEntity

        coreData.save()
    }
    
    public func updateCategory(of items: [Item], to category: ItemsCategory) {
        var categoryEntity: CategoryEntity?
        if !category.isDefault {
            categoryEntity = self.categoryEntity(from: category)
        }
        
        let itemEntities = self.itemEntities(with: items.map { $0.id })
        itemEntities.forEach { $0.category = categoryEntity }

        coreData.save()
    }

    private func itemEntity(with id: Id<Item>) -> ItemEntity? {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? coreData.context.fetch(request).first
    }

    private func itemEntities(with ids: [Id<Item>]) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids.map { $0.toString() })
        return (try? coreData.context.fetch(request)) ?? []
    }

    private func categoryEntity(from category: ItemsCategory) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id.toString())
        return try? coreData.context.fetch(request).first
    }

    public func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState) {
        let request: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "itemsState == %@", state.rawValue.description),
            NSPredicate(format: "listId == %@", list.id.toString())
        ])

        do {
            let entities = try coreData.context.fetch(request)
            if let entity = entities.first {
                coreData.context.delete(entity)
            }

            if items.count > 0 {
                let itemsOrder = ItemsOrder(state, list, items)
                _ = itemsOrder.map(context: coreData.context)
            }

            coreData.save()
        } catch {
            fatalError("Unable to fetch ItemsOrder: \(error)")
        }
    }

    private func listEntity(from id: Id<List>) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? coreData.context.fetch(request).first
    }

    private func itemEntities(by ids: [Id<Item>], context: NSManagedObjectContext) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id in %@", ids.map { $0.toString() })
        return (try? context.fetch(request)) ?? []
    }
}
