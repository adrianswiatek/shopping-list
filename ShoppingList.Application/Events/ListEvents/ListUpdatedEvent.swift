import ShoppingList_Domain

public struct ListUpdatedEvent: Event {
    public let id: Id<List>

    public init(_ id: Id<List>) {
        self.id = id
    }
}
