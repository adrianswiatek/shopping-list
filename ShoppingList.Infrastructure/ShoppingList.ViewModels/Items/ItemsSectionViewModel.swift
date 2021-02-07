import ShoppingList_Domain

public struct ItemsSectionViewModel {
    public let category: ItemsCategoryViewModel
    public let items: [ItemToBuyViewModel]

    public init(_ category: ItemsCategory, _ items: [Item]) {
        self.init(.init(category), items.map { .init($0, category) })
    }

    private init(_ category: ItemsCategoryViewModel, _ items: [ItemToBuyViewModel]) {
        self.category = category
        self.items = items
    }

    public func withRemovedItem(at index: Int) -> Self {
        var items = self.items
        items.remove(at: index)
        return .init(category, items)
    }

    public func withInsertedItem(_ item: ItemToBuyViewModel, at index: Int) -> Self {
        var items = self.items
        items.insert(item, at: index)
        return .init(category, items)
    }
}
