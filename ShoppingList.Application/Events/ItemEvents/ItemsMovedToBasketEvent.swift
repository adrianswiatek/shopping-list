import ShoppingList_Domain

public struct ItemsMovedToBasketEvent: Event {
    public let itemIds: [Id<Item>]
    public let listId: Id<List>

    public init(_ itemIds: [Id<Item>], _ listId: Id<List>) {
        self.itemIds = itemIds
        self.listId = listId
    }
}
