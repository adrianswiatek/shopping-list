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
    
    // Mark: - List
    
    func getLists() -> [List] {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        
        do {
            return try context.fetch(request).map { $0.map() }
        } catch {
            fatalError("Unable to fetch Lists: \(error)")
        }
    }
    
    func getList(by id: UUID) -> List? {
        return getListEntity(by: id)?.map()
    }
    
    func add(_ list: List) {
        _ = list.map(context: context)
        save()
    }
    
    func update(_ list: List) {
        guard let entity = getListEntity(by: list) else { return }
        entity.update(by: list, context: context)
        save()
    }
    
    func remove(_ list: List) {
        guard let entity = getListEntity(by: list) else { return }
        context.delete(entity)
        save()
    }
    
    // MARK: - Category
    
    func getCategories() -> [Category] {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            return try context.fetch(request).map { $0.map() }
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
        guard let entity = getCategoryEntity(by: category) else { return }
        context.delete(entity)
        save()
    }
    
    // MARK: - Item
    
    func getItems() -> [Item] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        
        do {
            return try context.fetch(request).map { $0.map() }
        } catch {
            fatalError("Unable to fetch Items: \(error)")
        }
    }
    
    func getItemsWith(state: ItemState, in list: List) -> [Item] {
        let itemsRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        itemsRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "state == %@", state.rawValue.description),
            NSPredicate(format: "list.id == %@", list.id as CVarArg)
        ])
        
        let itemsOrdersRequest: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        itemsOrdersRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "itemsState == %@", state.rawValue.description),
            NSPredicate(format: "listId == %@", list.id as CVarArg)
        ])
        
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
        let entity = item.map(context: context)
        entity.list?.updateDate = Date()
        save()
    }
    
    func remove(_ items: [Item]) {
        let entities = getItemEntities(by: items)
        if let entity = entities.first {
            entity.list?.updateDate = Date()
        }
        entities.forEach { context.delete($0) }
        save()
    }
    
    func remove(_ item: Item) {
        guard let entity = getItemEntity(by: item) else { return }
        entity.list?.updateDate = Date()
        context.delete(entity)
        save()
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        let entities = getItemEntities(by: items)
        if let entity = entities.first {
            entity.list?.updateDate = Date()
        }
        entities.forEach { $0.state = Int32(state.rawValue) }
        save()
    }
    
    func updateState(of item: Item, to state: ItemState) {
        guard let entity = getItemEntity(by: item) else { return }
        entity.state = Int32(state.rawValue)
        entity.list?.updateDate = Date()
        save()
    }

    func update(_ item: Item) {
        guard let entity = getItemEntity(by: item) else { return }
        entity.update(by: item, context: context)
        save()
    }
    
    func updateCategory(of item: Item, to category: Category) {
        guard let itemEntity = getItemEntity(by: item) else { return }
        
        var categoryEntity: CategoryEntity?
        if !category.isDefault() {
            categoryEntity = getCategoryEntityOrCreate(from: category)
        }
        
        itemEntity.category = categoryEntity
        itemEntity.list?.updateDate = Date()
        save()
    }
    
    func updateCategory(of items: [Item], to category: Category) {
        var categoryEntity: CategoryEntity?
        if !category.isDefault() {
            categoryEntity = getCategoryEntityOrCreate(from: category)
        }
        
        let itemEntities = getItemEntities(by: items)
        if let entity = itemEntities.first {
            entity.list?.updateDate = Date()
        }
        itemEntities.forEach { $0.category = categoryEntity }
        save()
    }
    
    // MARK: - Items Order
    
    func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState) {
        guard let listEntity = getListEntity(by: list) else { return }
        listEntity.updateDate = Date()
        
        let request: NSFetchRequest<ItemsOrderEntity> = ItemsOrderEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "itemsState == %@", state.rawValue.description),
            NSPredicate(format: "listId == %@", list.id as CVarArg) 
        ])

        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
            }

            if items.count > 0 {
                let itemsOrder = ItemsOrder(state, list, items)
                _ = itemsOrder.map(context: context)
            }

            save()
        } catch {
            fatalError("Unable to fetch ItemsOrder: \(error)")
        }
    }
    
    // MARK: - Other
    
    func save() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func getListEntity(by id: UUID) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch List: \(error)")
        }
    }
    
    private func getListEntity(by list: List) -> ListEntity? {
        return getListEntity(by: list.id)
    }
    
    private func getListEntityOrCreate(from list: List) -> ListEntity? {
        return getListEntity(by: list) ?? list.map(context: context)
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
}
