import ShoppingList_Domain

public struct ItemRemovedEvent: Event {
    public let id: Id<Item>

    public init(_ id: Id<Item>) {
        self.id = id
    }
}
