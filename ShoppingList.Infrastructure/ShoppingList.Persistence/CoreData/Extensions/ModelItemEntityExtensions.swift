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

    func update(by modelItem: ModelItem, context: NSManagedObjectContext) {
        guard id == modelItem.id.toUuid() else {
            fatalError("Unable to update Categories that have different ids.")
        }

        Optional(modelItem)
            .guard { $0.name != name }
            .do { name = $0.name }

        Optional(modelItem)
            .guard { $0.categoryId.toUuid() != category?.id }
            .do { category = categoryEntity(from: $0, context: context) }
    }

    private func categoryEntity(
        from modelItem: ModelItem,
        context: NSManagedObjectContext
    ) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", modelItem.categoryId.toString())

        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unable to fetch Category: \(error)")
        }
    }
}
