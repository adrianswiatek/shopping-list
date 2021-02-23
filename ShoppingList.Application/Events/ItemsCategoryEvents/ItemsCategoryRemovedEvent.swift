import ShoppingList_Domain

public struct ItemsCategoryRemovedEvent: Event {
    public let category: ItemsCategory

    public init(_ category: ItemsCategory) {
        self.category = category
    }
}
