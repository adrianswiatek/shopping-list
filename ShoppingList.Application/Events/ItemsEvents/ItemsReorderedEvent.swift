import ShoppingList_Domain

public struct ItemsReorderedEvent: Event {
    public let listId: Id<List>

    public init(_ listId: Id<List>) {
        self.listId = listId
    }
}
