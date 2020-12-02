import ShoppingList_Domain

public protocol CategoryRepository {
    func getCategories() -> [ItemsCategory]
    func add(_ category: ItemsCategory)
    func update(_ category: ItemsCategory)
    func remove(_ category: ItemsCategory)
}
