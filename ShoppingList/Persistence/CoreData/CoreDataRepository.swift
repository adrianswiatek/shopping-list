import CoreData

class CoreDataRepository: RepositoryProtocol {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getItemsWith(state: ItemState) -> [Item] {
        let itemsRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        itemsRequest.predicate = NSPredicate(format: "state == %@", state.rawValue.description)
        
        let itemsOrdersRequest: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        itemsOrdersRequest.predicate = NSPredicate(format: "itemsState == %@", state.rawValue.description)
        
        do {
            let itemsEntities = try context.fetch(itemsRequest)
            let unorderedItems = itemsEntities.map { $0.map() }
            var orderedItemsIds = [UUID]()
            
            let itemsOrdersEntities = try context.fetch(itemsOrdersRequest)
            if let itemsOrderEntity = itemsOrdersEntities.first {
                let itemsOrder = itemsOrderEntity.map()
                orderedItemsIds = itemsOrder.itemsIds
            }
            
            return ItemsSorter.sort(unorderedItems, by: orderedItemsIds)
        } catch {
            fatalError("Unable to fetch Items: \(error)")
        }
    }
    
    func add(_ item: Item) {
        _ = item.map(context: context)
        save()
    }
    
    func remove(_ items: [Item]) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", items.map { $0.id })
        
        do {
            let entities = try context.fetch(request)
            entities.forEach { context.delete($0) }
            save()
        } catch {
            fatalError("Unable to delete Items: \(error)")
        }
    }
    
    func remove(_ item: Item) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            guard let entity = try context.fetch(request).first else { return }
            context.delete(entity)
            save()
        } catch {
            fatalError("Unable to delete Item: \(error)")
        }
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", items.map { $0.id })
        
        do {
            let entities = try context.fetch(request)
            entities.forEach { $0.state = Int32(state.rawValue)}
            save()
        } catch {
            fatalError("Unable to update state of Item: \(error)")
        }
    }
    
    func updateState(of item: Item, to state: ItemState) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            guard let entity = entities.first else { return }
            entity.state = Int32(state.rawValue)
            save()
        } catch {
            fatalError("Unable to update state of Item: \(error)")
        }
    }

    func setItemsOrder(_ items: [Item], forState state: ItemState) {
        let request: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "itemsState == %@", state.rawValue.description)
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
            }
            
            let itemsOrder = ItemsOrder(state, items)
            _ = itemsOrder.map(context: context)
            save()
        } catch {
            fatalError("Unable to fetch ItemsOrder: \(error)")
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
