import ShoppingList_Domain
import ShoppingList_Shared
import CoreData

extension ItemEntity {
    func toItem() -> Item {
        guard
            let uuid = id,
            let name = name,
            let state = ItemState(rawValue: Int(state)),
            let listUuid = list?.id
        else {
            fatalError("Unable to create Item")
        }

        return Item(
            id: .fromUuid(uuid),
            name: name,
            info: info,
            state: state,
            categoryId: category?.map().id,
            listId: .fromUuid(listUuid),
            externalUrl: externalUrl
        )
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

        if externalUrl != item.externalUrl {
            externalUrl = item.externalUrl
            hasBeenUpdated = true
        }

        if category?.id != item.categoryId.toUuid() {
            category = categoryEntity(from: item, context: context)
            hasBeenUpdated = true
        }
        
        if list?.id != item.listId.toUuid() {
            list = listEntity(from: item, context: context)
            hasBeenUpdated = true
        }

        if hasBeenUpdated {
            list?.updateDate = Date()
        }
    }
    
    private func categoryEntity(from item: Item, context: NSManagedObjectContext) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.categoryId.toString())
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch Category: \(error)")
        }
    }
    
    private func listEntity(from item: Item, context: NSManagedObjectContext) -> ListEntity? {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.listId.toString())
        return try? context.fetch(request).first
    }
}
