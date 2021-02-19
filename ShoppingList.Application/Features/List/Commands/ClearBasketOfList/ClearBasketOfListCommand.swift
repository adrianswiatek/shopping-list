import ShoppingList_Domain

public struct ClearBasketOfListCommand: Command {
    public let source: CommandSource

    internal let id: Id<List>
    internal let items: [Item]

    public init(_ id: Id<List>) {
        self.init(id, [])
    }

    private init(_ id: Id<List>, _ items: [Item]) {
        self.id = id
        self.items = items
        self.source = .lists
    }

    public func reversed() -> Command? {
        !items.isEmpty ? RestoreListItemsCommand(items) : nil
    }

    internal func withItems(_ items: [Item]) -> Command {
        ClearBasketOfListCommand(id, items)
    }
}
