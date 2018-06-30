import CoreData

extension ItemEntity {
    func map() -> Item {
        guard let list = self.list?.map() else { fatalError("Unable to create Item") }
        return map(with: list)
    }
    
    func map(with list: List) -> Item {
        guard
            let id = self.id,
            let name = self.name,
            let state = ItemState(rawValue: Int(self.state))
        else { fatalError("Unable to create Item") }
        
        let category = self.category?.map()
        return Item(id: id, name: name, state: state, category: category, list: list)
    }
    
    func update(by item: Item, context: NSManagedObjectContext) {
        guard self.id == item.id else {
            fatalError("Unable to update Categories that have different ids.")
        }
        
        var hasBeenUpdated = false
        
        if self.name != item.name {
            self.name = item.name
            hasBeenUpdated = true
        }
        
        if self.state != Int32(item.state.rawValue) {
            self.state = Int32(item.state.rawValue)
            hasBeenUpdated = true
        }
        
        if self.category?.id != item.category?.id {
            self.category = getCategoryEntity(from: item, context: context)
            hasBeenUpdated = true
        }
        
        if self.list?.id != item.list.id {
            self.list = getListEntity(from: item, context: context)
            hasBeenUpdated = true
        }
        
        if hasBeenUpdated {
            self.list?.updateDate = Date()
        }
    }
    
    private func getCategoryEntity(from item: Item, context: NSManagedObjectContext) -> CategoryEntity? {
        guard let category = item.category else { return nil }
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch Category: \(error)")
        }
    }
    
    private func getListEntity(from item: Item, context: NSManagedObjectContext) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch List: \(error)")
        }
    }
}

extension Item {
    func map(context: NSManagedObjectContext) -> ItemEntity {
        let entity = ItemEntity(context: context)
        entity.id = self.id
        entity.name = self.name
        entity.state = Int32(self.state.rawValue)
        entity.list = getListEntity(withId: self.list.id, context: context)
        
        if let categoryId = self.category?.id {
            entity.category = getCategoryEntity(withId: categoryId, context: context)
        }
        
        return entity
    }
    
    private func getListEntity(withId id: UUID, context: NSManagedObjectContext) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch List")
        }
    }
    
    private func getCategoryEntity(withId id: UUID, context: NSManagedObjectContext) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch Category")
        }
    }
}
