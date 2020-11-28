import ShoppingList_Domain
import ShoppingList_Shared
import CoreData

extension CategoryEntity {
    func map() -> ItemsCategory {
        guard let id = id, let name = name else {
            fatalError("Unable to create Category")
        }
        
        return ItemsCategory(id: id, name: name)
    }
    
    func update(by category: ItemsCategory) {
        guard self.id == category.id else {
            fatalError("Unable to update Categories that have different ids.")
        }
        
        name = category.name
    }
}

extension ItemsCategory {
    func map(context: NSManagedObjectContext) -> CategoryEntity {
        configure(.init(context: context)) {
            $0.id = id
            $0.name = name
        }
    }
}
