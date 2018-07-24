import CoreData

extension ListEntity {
    func map() -> List {
        guard
            let id = self.id,
            let name = self.name,
            let accessType = ListAccessType(rawValue: Int(self.accessType)),
            let items = self.items?.compactMap({ $0 as? ItemEntity }),
            let updateDate = self.updateDate
        else { fatalError("Unable to create List") }
        
        let list = List(id: id, name: name, accessType: accessType, items: [], updateDate: updateDate)
        let mappedItems = items.map({ $0.map(with: list) })
        return list.getWithTheSameUpdateDateAndWithAdded(items: mappedItems)
    }
    
    func update(by list: List, context: NSManagedObjectContext) {
        guard self.id == list.id else {
            fatalError("Unable to update Lists that have different ids.")
        }
        
        if self.name != list.name {
            self.name = list.name
        }
        
        if self.accessType != Int32(list.accessType.rawValue) {
            self.accessType = Int32(list.accessType.rawValue)
        }
        
        if self.updateDate != list.updateDate {
            self.updateDate = list.updateDate
        }
        
        updateItemEntities(by: list.items, context: context)
    }
    
    private func updateItemEntities(by items: [Item], context: NSManagedObjectContext) {
        var itemsToUpdate = items
        var entitiesToUpdate = getItemEntities(by: items, context: context)
        
        for entity in entitiesToUpdate {
            guard let item = items.first(where: { $0.id == entity.id }) else { continue }
            
            entity.update(by: item, context: context)
            
            if let index = entitiesToUpdate.index(where: { $0.id == item.id }) {
                entitiesToUpdate.remove(at: index)
            }
            
            if let index = itemsToUpdate.index(where: { $0.id == item.id }) {
                itemsToUpdate.remove(at: index)
            }
        }
        
        itemsToUpdate.forEach { _ = $0.map(context: context) }
        entitiesToUpdate.forEach { context.delete($0) }
    }
    
    private func getItemEntities(by items: [Item], context: NSManagedObjectContext) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", items.map { $0.id })
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Unable to fetch Items: \(error)")
        }
    }
}

extension List {
    func map(context: NSManagedObjectContext) -> ListEntity {
        let entity = ListEntity(context: context)
        entity.id = self.id
        entity.name = self.name
        entity.accessType = Int32(self.accessType.rawValue)
        entity.updateDate = self.updateDate
        
        let itemEntities = fetchItemEntities(by: self.items.map { $0.id }, context: context)
        entity.items = NSSet(array: itemEntities)
        
        return entity
    }
    
    private func fetchItemEntities(by ids: [UUID], context: NSManagedObjectContext) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id in %@", ids)
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Unable to fetch Items: \(error)")
        }
    }
}