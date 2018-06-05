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
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "state == %@", state.rawValue.description)
    
        do {
            let entities = try context.fetch(request)
            return entities.map { $0.map() }
        } catch {
            fatalError("Unable to fetch Items: \(error)")
        }
    }
    
    func add(_ item: Item) {
        let itemEntity = ItemEntity(context: context)
        itemEntity.id = item.id
        itemEntity.name = item.name
        itemEntity.state = Int32(item.state.rawValue)
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
            fatalError("Unable to update Item: \(error)")
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
            fatalError("Unable to update Item: \(error)")
        }
    }

    func setItemsOrder(_ items: [Item], forState state: ItemState) {
        fatalError("Not implemented")
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
