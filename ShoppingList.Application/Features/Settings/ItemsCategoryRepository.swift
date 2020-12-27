import ShoppingList_Domain

public protocol ItemsCategoryRepository {
    func allCategories() -> [ItemsCategory]
    func category(with id: UUID) -> ItemsCategory?
    func add(_ category: ItemsCategory)
    func update(_ category: ItemsCategory)
    func remove(by id: UUID)
}
