import ShoppingList_Domain

public struct RemoveItemsCommand: Command {
    public let ids: [Id<Item>]
    public let source: CommandSource

    private let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
        self.ids = items.map { $0.id }
        self.source = .items
    }

    public func reversed() -> Command? {
        guard !items.isEmpty else { return nil }
        return RestoreItemsCommand(items)
    }
}
