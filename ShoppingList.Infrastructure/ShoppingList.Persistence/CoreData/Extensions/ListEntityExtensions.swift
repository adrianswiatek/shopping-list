import ShoppingList_Domain
import CoreData

extension ListEntity {
    func map() -> List {
        guard
            let id = id,
            let name = name,
            let accessType = ListAccessType(rawValue: Int(accessType)),
            let items = items?.compactMap({ $0 as? ItemEntity }),
            let updateDate = updateDate
        else {
            fatalError("Unable to create List.")
        }
        
        let list = List(id: .fromUuid(id), name: name, accessType: accessType, items: [], updateDate: updateDate)
        return list.withTheSameUpdateDateAndWithAddedItems(items.map { $0.map(with: list) })
    }
    
    func update(by list: List, context: NSManagedObjectContext) {
        guard id == list.id.toUuid() else {
            fatalError("Unable to update Lists that have different ids.")
        }
        
        if name != list.name {
            name = list.name
        }
        
        if accessType != Int32(list.accessType.rawValue) {
            accessType = Int32(list.accessType.rawValue)
        }
        
        if updateDate != list.updateDate {
            updateDate = list.updateDate
        }
        
        updateItemEntities(by: list.items, context: context)
    }
    
    private func updateItemEntities(by items: [Item], context: NSManagedObjectContext) {
        var itemsToUpdate = items
        var entitiesToUpdate = getItemEntities(by: items, context: context)
        
        for entity in entitiesToUpdate {
            guard let item = items.first(where: { $0.id.toUuid() == entity.id }) else { continue }
            
            entity.update(by: item, context: context)
            
            if let index = entitiesToUpdate.firstIndex(where: { $0.id == item.id.toUuid() }) {
                entitiesToUpdate.remove(at: index)
            }
            
            if let index = itemsToUpdate.firstIndex(where: { $0.id == item.id }) {
                itemsToUpdate.remove(at: index)
            }
        }
        
        itemsToUpdate.forEach { _ = $0.map(context: context) }
        entitiesToUpdate.forEach { context.delete($0) }
    }
    
    private func getItemEntities(by items: [Item], context: NSManagedObjectContext) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", items.map { $0.id.toString() })
        return (try? context.fetch(request)) ?? []
    }
}

extension List {
    func map(context: NSManagedObjectContext) -> ListEntity {
        let entity = ListEntity(context: context)
        entity.id = id.toUuid()
        entity.name = name
        entity.accessType = Int32(accessType.rawValue)
        entity.updateDate = updateDate
        
        let itemEntities = self.itemEntities(by: items.map { $0.id }, context: context)
        entity.items = NSSet(array: itemEntities)
        
        return entity
    }
    
    private func itemEntities(by ids: [Id<Item>], context: NSManagedObjectContext) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id in %@", ids.map { $0.toString() })
        return (try? context.fetch(request)) ?? []
    }
}
