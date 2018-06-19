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
    
    func getCategories() -> [Category] {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.map { $0.map() }
        } catch {
            fatalError("Unable to fetch Categories: \(error)")
        }
    }
    
    func add(_ category: Category) {
        _ = category.map(context: context)
        save()
    }
    
    func update(_ category: Category) {
        guard let entity = getCategoryEntity(by: category) else { return }
        entity.update(by: category)
        save()
    }
    
    func remove(_ category: Category) {
        if let entity = getCategoryEntity(by: category) {
            context.delete(entity)
            save()
        }
    }
    
    func getItems() -> [Item] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        
        do {
            return try context.fetch(request).map { $0.map() }
        } catch {
            fatalError("Unable to fetch Items: \(error)")
        }
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
        let entities = getItemEntities(by: items)
        entities.forEach { context.delete($0) }
        save()
    }
    
    func remove(_ item: Item) {
        if let entity = getItemEntity(by: item) {
            context.delete(entity)
            save()
        }
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        let entities = getItemEntities(by: items)
        entities.forEach { $0.state = Int32(state.rawValue)}
        save()
    }
    
    func updateState(of item: Item, to state: ItemState) {
        if let entity = getItemEntity(by: item) {
            entity.state = Int32(state.rawValue)
            save()
        }
    }

    func update(_ item: Item) {
        guard let itemEntity = getItemEntity(by: item) else { return }
        
        var categoryEntity: CategoryEntity?
        if let category = item.category {
            categoryEntity = getCategoryEntity(by: category)
        }
        
        itemEntity.name = item.name
        itemEntity.state = Int32(item.state.rawValue)
        itemEntity.category = categoryEntity
        
        save()
    }
    
    func updateCategory(of item: Item, to category: Category) {
        guard let itemEntity = getItemEntity(by: item) else { return }
        
        var categoryEntity: CategoryEntity?
        
        if !category.isDefault() {
            categoryEntity = getCategoryEntityOrCreate(from: category)
        }
        
        itemEntity.category = categoryEntity
        
        save()
    }
    
    func updateCategory(of items: [Item], to category: Category) {
        var categoryEntity: CategoryEntity?
        if !category.isDefault() {
            categoryEntity = getCategoryEntityOrCreate(from: category)
        }
        
        let itemEntities = getItemEntities(by: items)
        itemEntities.forEach { $0.category = categoryEntity }
        save()
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
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func getItemEntity(by item: Item) -> ItemEntity? {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch  {
            fatalError("Unable to fetch Item: \(error)")
        }
    }
    
    private func getItemEntities(by items: [Item]) -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", items.map { $0.id })
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Unable to fetch Items: \(error)")
        }
    }
    
    private func getCategoryEntity(by category: Category) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch Category: \(error)")
        }
    }
    
    private func getCategoryEntityOrCreate(from category: Category) -> CategoryEntity? {
        return getCategoryEntity(by: category) ?? category.map(context: context)
    }
}
