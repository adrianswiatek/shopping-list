import ShoppingList_Domain

public struct ItemsCategoryAddedEvent: Event {
    public let id: Id<ItemsCategory>

    public init(_ id: Id<ItemsCategory>) {
        self.id = id
    }
}
