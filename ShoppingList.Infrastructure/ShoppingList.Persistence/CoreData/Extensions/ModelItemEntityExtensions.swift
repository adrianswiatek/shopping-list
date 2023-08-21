import ShoppingList_Domain
import ShoppingList_Shared
import CoreData

extension ModelItemEntity {
    func map() -> ModelItem {
        guard let id, let name else {
            fatalError("Unable to create ModelItem.")
        }
        return ModelItem(id: .fromUuid(id), name: name)
    }

    func update(by modelItem: ModelItem, context: NSManagedObjectContext) {
        guard id == modelItem.id.toUuid(), name != modelItem.name else {
            fatalError("Unable to update Categories that have different ids.")
        }
        name = modelItem.name
    }
}
