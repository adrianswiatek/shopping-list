import ShoppingList_Domain

public struct MoveItemsToListCommand: Command {
    public let ids: [Id<Item>]
    public let source: CommandSource

    public init(_ ids: [Id<Item>]) {
        self.ids = ids
        self.source = .basket
    }

    public func reversed() -> Command? {
        guard !ids.isEmpty else { return nil }
        return MoveItemsToBasketCommand(ids)
    }
}
