import ShoppingList_Domain

public struct MoveItemsToListCommand: Command {
    public let itemIds: [Id<Item>]
    public let listId: Id<List>
    public let source: CommandSource

    public init(_ itemIds: [Id<Item>], _ listId: Id<List>) {
        self.itemIds = itemIds
        self.listId = listId
        self.source = .basket
    }

    public func reversed() -> Command? {
        guard !itemIds.isEmpty else { return nil }
        return MoveItemsToBasketCommand(itemIds, listId)
    }
}
