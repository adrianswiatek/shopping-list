import ShoppingList_Domain

public protocol ItemsCategoryQueries {
    func fetchCategories() -> [ItemsCategory]
}
