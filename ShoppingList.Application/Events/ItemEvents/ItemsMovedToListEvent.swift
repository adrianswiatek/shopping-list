import ShoppingList_Domain

public struct ItemsMovedToListEvent: Event {
    public let ids: [Id<Item>]
    public let listId: Id<List>

    public init(_ ids: [Id<Item>], _ listId: Id<List>) {
        self.ids = ids
        self.listId = listId
    }
}
