import ShoppingList_Domain

public struct MoveItemsToBasketCommand: Command {
    public let source: CommandSource

    internal let itemIds: [Id<Item>]
    internal let listId: Id<List>

    public init(_ itemIds: [Id<Item>], _ listId: Id<List>) {
        self.itemIds = itemIds
        self.listId = listId
        self.source = .items
    }

    public func reversed() -> Command? {
        MoveItemsToListCommand(itemIds, listId)
    }
}
