import ShoppingList_Domain
import ShoppingList_Shared
import CoreData

extension ModelItemEntity {
    func map() -> ModelItem {
        guard
            let id = id,
            let name = name,
            let categoryId = category?.map().id
        else {
            fatalError("Unable to create ModelItem.")
        }

        return ModelItem(
            id: .fromUuid(id),
            name: name,
            categoryId: categoryId
        )
    }
}
