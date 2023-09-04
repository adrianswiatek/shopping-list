import ShoppingList_Domain

public final class ItemsCategoryService: ItemsCategoryQueries {
    private let categoryRepository: ItemsCategoryRepository
    private let localPreferences: LocalPreferences

    public init(_ categoryRepository: ItemsCategoryRepository, _ localPreferences: LocalPreferences) {
        self.categoryRepository = categoryRepository
        self.localPreferences = localPreferences
    }

    public func fetchCategories() -> [ItemsCategory] {
        var categories = categoryRepository.allCategories()

        let (defaultCategory, index) = defaultCategoryWithIndex(from: categories)
        categories[index] = defaultCategory

        return categories.sorted { $0.name < $1.name }
    }

    private func defaultCategoryWithIndex(
        from categories: [ItemsCategory]
    ) -> (category: ItemsCategory, index: Int) {
        let category = categories.enumerated().first { $0.element.id == ItemsCategory.default.id }
        precondition(category != nil, "Default category must be persisted.")

        let categoryName = localPreferences.defaultCategoryName
        return (category!.element.withName(categoryName), category!.offset)
    }
}
