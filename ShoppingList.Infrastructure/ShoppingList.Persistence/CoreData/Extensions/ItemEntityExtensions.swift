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
        else { fatalError("Unable to create Item") }
        
        let category = self.category?.map()
        return Item(id: id, name: name, info: self.info, state: state, category: category, list: list)
    }
    
    func update(by item: Item, context: NSManagedObjectContext) {
        guard id == item.id else {
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
        
        if category?.id != item.category.id {
            category = getCategoryEntity(from: item, context: context)
            hasBeenUpdated = true
        }
        
        if list?.id != item.list.id {
            list = getListEntity(from: item, context: context)
            hasBeenUpdated = true
        }
        
        if hasBeenUpdated {
            list?.updateDate = Date()
        }
    }
    
    private func getCategoryEntity(from item: Item, context: NSManagedObjectContext) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.category.id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch Category: \(error)")
        }
    }
    
    private func getListEntity(from item: Item, context: NSManagedObjectContext) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.list.id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch List: \(error)")
        }
    }
}

extension Item {
    func map(context: NSManagedObjectContext) -> ItemEntity {
        configure(.init(context: context)) {
            $0.id = id
            $0.name = name
            $0.info = info
            $0.state = Int32(state.rawValue)
            $0.list = getListEntity(withId: list.id, context: context)
            $0.category = getCategoryEntity(withId: category.id, context: context)
        }
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
