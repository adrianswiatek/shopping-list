import ShoppingList_Domain

public final class ItemsCategoryService: ItemsCategoryQueries {
    private let categoryRepository: ItemsCategoryRepository

    public init(_ categoryRepository: ItemsCategoryRepository) {
        self.categoryRepository = categoryRepository
    }

    public func fetchCategories() -> [ItemsCategory] {
        var categories = categoryRepository.allCategories()

        let containsDefault = categories.contains { $0.id == ItemsCategory.default.id }
        if !containsDefault {
            categories.append(ItemsCategory.default)
        }

        return categories.sorted { $0.name < $1.name }
    }
}
