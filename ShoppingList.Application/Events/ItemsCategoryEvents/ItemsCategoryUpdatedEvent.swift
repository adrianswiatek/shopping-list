import ShoppingList_Domain

public struct ItemsCategoryUpdatedEvent: Event {
    public let id: Id<ItemsCategory>

    public init(_ id: Id<ItemsCategory>) {
        self.id = id
    }
}
