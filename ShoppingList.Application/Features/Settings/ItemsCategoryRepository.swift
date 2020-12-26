import ShoppingList_Domain

public protocol ItemsCategoryRepository {
    func allCategories() -> [ItemsCategory]
    func add(_ category: ItemsCategory)
    func update(_ category: ItemsCategory)
    func remove(by id: UUID)
}

extension ItemsCategoryRepository {
    public var defaultCategoryName: String {
        get { UserDefaults.standard.string(forKey: defaultCategoryNameKey) ?? "Other" }
        set { UserDefaults.standard.set(newValue, forKey: defaultCategoryNameKey) }
    }

    private var defaultCategoryNameKey: String {
        "DefaultCategoryName"
    }
}
