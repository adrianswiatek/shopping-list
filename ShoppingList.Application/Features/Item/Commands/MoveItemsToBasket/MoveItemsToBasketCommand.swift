import ShoppingList_Domain

public struct MoveItemsToBasketCommand: Command {
    public let itemIds: [Id<Item>]
    public let listId: Id<List>
    public let source: CommandSource

    public init(_ itemIds: [Id<Item>], _ listId: Id<List>) {
        self.itemIds = itemIds
        self.listId = listId
        self.source = .items
    }

    public func reversed() -> Command? {
        MoveItemsToListCommand(itemIds, listId)
    }
}
