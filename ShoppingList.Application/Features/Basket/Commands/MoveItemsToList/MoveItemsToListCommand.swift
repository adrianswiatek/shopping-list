import ShoppingList_Domain

public struct MoveItemsToListCommand: Command {
    public let source: CommandSource

    internal let itemIds: [Id<Item>]
    internal let listId: Id<List>

    public init(_ itemIds: [Id<Item>], _ listId: Id<List>) {
        self.itemIds = itemIds
        self.listId = listId
        self.source = .basket
    }

    public func reversed() -> Command? {
        !itemIds.isEmpty ? MoveItemsToBasketCommand(itemIds, listId) : nil
    }
}
