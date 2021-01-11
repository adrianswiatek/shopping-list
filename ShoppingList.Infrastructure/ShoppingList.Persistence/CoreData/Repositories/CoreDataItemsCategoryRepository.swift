import ShoppingList_Application
import ShoppingList_Domain
import CoreData

public final class CoreDataItemsCategoryRepository: ItemsCategoryRepository {
    private let coreData: CoreDataStack

    public init(_ coreData: CoreDataStack) {
        self.coreData = coreData
    }

    public func allCategories() -> [ItemsCategory] {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        return (try? coreData.context.fetch(request).map { $0.map() }) ?? []
    }

    public func category(with id: Id<ItemsCategory>) -> ItemsCategory? {
        categoryEntity(with: id)?.map()
    }

    public func add(_ category: ItemsCategory) {
        let entity = category.map(context: coreData.context)
        coreData.context.insert(entity)
        coreData.save()
    }

    public func update(_ category: ItemsCategory) {
        guard let entity = categoryEntity(with: category.id) else { return }
        entity.update(by: category)
        coreData.save()
    }

    public func remove(by id: Id<ItemsCategory>) {
        guard let entity = categoryEntity(with: id) else { return }
        coreData.context.delete(entity)
        coreData.save()
    }

    private func categoryEntity(with id: Id<ItemsCategory>) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.toString())
        return try? coreData.context.fetch(request).first
    }
}
