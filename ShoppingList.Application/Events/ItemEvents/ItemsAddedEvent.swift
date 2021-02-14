import ShoppingList_Domain

public struct ItemsAddedEvent: Event {
    public let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
    }
}
