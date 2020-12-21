import ShoppingList_Domain

public protocol ItemsCategoryRepository {
    func getCategories() -> [ItemsCategory]
    func add(_ category: ItemsCategory)
    func update(_ category: ItemsCategory)
    func remove(by id: UUID)
}
