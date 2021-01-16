import ShoppingList_Domain
import ShoppingList_Shared
import CoreData

extension CategoryEntity {
    func map() -> ItemsCategory {
        guard let id = id, let name = name else {
            fatalError("Unable to create Category.")
        }
        
        return ItemsCategory(id: .fromUuid(id), name: name, itemsCount: items?.count ?? 0)
    }
    
    func update(by category: ItemsCategory) {
        guard id == category.id.toUuid() else {
            fatalError("Unable to update Categories that have different ids.")
        }
        
        name = category.name
    }
}

extension ItemsCategory {
    func map(context: NSManagedObjectContext) -> CategoryEntity {
        configure(.init(context: context)) {
            $0.id = id.toUuid()
            $0.name = name
        }
    }
}
