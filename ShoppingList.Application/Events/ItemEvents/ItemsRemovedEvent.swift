import ShoppingList_Domain

public struct ItemsRemovedEvent: Event {
    public let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
    }
}
