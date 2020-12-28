import ShoppingList_Application
import ShoppingList_Domain
import CoreData

public final class CoreDataItemRepository: ItemRepository {
    private let coreData: CoreDataStack

    public init(_ coreData: CoreDataStack) {
        self.coreData = coreData
    }

    public func allItems() -> [Item] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }
    
    public func itemsWith(state: ItemState, inListWithId listId: UUID) -> [Item] {
        let itemsRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        itemsRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "state == %@", state.rawValue.description),
            NSPredicate(format: "list.id == %@", listId as CVarArg)
        ])
        
        let itemsOrdersRequest: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        itemsOrdersRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "itemsState == %@", state.rawValue.description),
            NSPredicate(format: "listId == %@", listId as CVarArg)
        ])
        
        do {
            let itemsEntities = try coreData.context.fetch(itemsRequest)
            let unorderedItems = itemsEntities.map { $0.map() }
            var orderedItemsIds = [UUID]()
            
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

    public func items(in category: ItemsCategory) -> [Item] {
        let categoryEntity = self.categoryEntity(from: category)
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", categoryEntity)
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }

    public func numberOfItemsWith(state: ItemState, inListWithId listId: UUID) -> Int {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "state == %@", state.rawValue.description),
            NSPredicate(format: "list.id == %@", listId as CVarArg)
        ])
        return (try? coreData.context.count(for: request)) ?? 0
    }
    
    public func numberOfItemsInList(with id: UUID) -> Int {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "list.id == $@", id as CVarArg)
        return (try? coreData.context.count(for: request)) ?? 0
    }
    
    public func add(_ item: Item) {
        let entity = item.map(context: coreData.context)
        entity.list?.updateDate = Date()
        coreData.context.insert(entity)
        coreData.save()
    }
    
    public func add(_ items: [Item]) {
        for item in items {
            let entity = item.map(context: coreData.context)
            entity.list?.updateDate = Date()
            coreData.context.insert(entity)
        }

        coreData.save()
    }
    
    public func remove(_ items: [Item]) {
        let entities = itemEntities(with: items.map { $0.id })
        entities.first?.list?.updateDate = Date()
        entities.forEach { coreData.context.delete($0) }
        coreData.save()
    }
    
    public func remove(_ item: Item) {
        guard let entity = itemEntity(with: item.id) else { return }
        entity.list?.updateDate = Date()
        coreData.context.delete(entity)
        coreData.save()
    }
    
    public func updateState(of items: [Item], to state: ItemState) {
        let entities = itemEntities(with: items.map { $0.id })
        entities.first?.list?.updateDate = Date()
        entities.forEach { $0.state = Int32(state.rawValue) }
        coreData.save()
    }
    
    public func updateState(of item: Item, to state: ItemState) {
        guard let entity = itemEntity(with: item.id) else { return }
        entity.state = Int32(state.rawValue)
        entity.list?.updateDate = Date()
        coreData.save()
    }

    public func update(_ item: Item) {
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
        itemEntity.list?.updateDate = Date()

        coreData.save()
    }
    
    public func updateCategory(of items: [Item], to category: ItemsCategory) {
        var categoryEntity: CategoryEntity?
        if !category.isDefault {
            categoryEntity = self.categoryEntity(from: category)
        }
        
        let itemEntities = self.itemEntities(with: items.map { $0.id })
        itemEntities.first?.list?.updateDate = Date()
        itemEntities.forEach { $0.category = categoryEntity }

        coreData.save()
    }

    private func itemEntity(with id: UUID) -> ItemEntity? {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? coreData.context.fetch(request).first
    }

    private func itemEntities(with ids: [UUID]) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids)
        return (try? coreData.context.fetch(request)) ?? []
    }

    private func categoryEntity(from category: ItemsCategory) -> CategoryEntity {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
        return (try? coreData.context.fetch(request).first) ?? category.map(context: coreData.context)
    }

    public func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState) {
        guard let listEntity = listEntity(from: list) else { return }
        listEntity.updateDate = Date()

        let request: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "itemsState == %@", state.rawValue.description),
            NSPredicate(format: "listId == %@", list.id as CVarArg)
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

    private func listEntity(from list: List) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
        return try? coreData.context.fetch(request).first ?? list.map(context: coreData.context)
    }
}
