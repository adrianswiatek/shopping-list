import ShoppingList_Domain
import ShoppingList_Shared
import CoreData

extension ItemEntity {
    func map() -> Item {
        guard let list = list?.map() else { fatalError("Unable to create Item") }
        return map(with: list)
    }
    
    func map(with list: List) -> Item {
        guard
            let id = id,
            let name = name,
            let state = ItemState(rawValue: Int(self.state))
        else {
            fatalError("Unable to create Item")
        }
        
        let category = self.category?.map()
        return Item(id: .fromUuid(id), name: name, info: self.info, state: state, category: category, list: list)
    }
    
    func update(by item: Item, context: NSManagedObjectContext) {
        guard id == item.id.toUuid() else {
            fatalError("Unable to update Categories that have different ids.")
        }
        
        var hasBeenUpdated = false
        
        if name != item.name {
            name = item.name
            hasBeenUpdated = true
        }
        
        if info != item.info {
            info = item.info
            hasBeenUpdated = true
        }
        
        if state != Int32(item.state.rawValue) {
            state = Int32(item.state.rawValue)
            hasBeenUpdated = true
        }
        
        if category?.id != item.category.id.toUuid() {
            category = categoryEntity(from: item, context: context)
            hasBeenUpdated = true
        }
        
        if list?.id != item.list.id.toUuid() {
            list = listEntity(from: item, context: context)
            hasBeenUpdated = true
        }
        
        if hasBeenUpdated {
            list?.updateDate = Date()
        }
    }
    
    private func categoryEntity(from item: Item, context: NSManagedObjectContext) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.category.id.toString())
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch Category: \(error)")
        }
    }
    
    private func listEntity(from item: Item, context: NSManagedObjectContext) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.list.id.toString())
        return try? context.fetch(request).first
    }
}

extension Item {
    func map(context: NSManagedObjectContext) -> ItemEntity {
        configure(.init(context: context)) {
            $0.id = id.toUuid()
            $0.name = name
            $0.info = info
            $0.state = Int32(state.rawValue)
            $0.list = listEntity(withId: list.id, context: context)
            $0.category = categoryEntity(withId: category.id, context: context)
        }
    }
    
    private func listEntity(withId id: Id<List>, context: NSManagedObjectContext) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? context.fetch(request).first
    }
    
    private func categoryEntity(withId id: Id<Category>, context: NSManagedObjectContext) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? context.fetch(request).first
    }
}
