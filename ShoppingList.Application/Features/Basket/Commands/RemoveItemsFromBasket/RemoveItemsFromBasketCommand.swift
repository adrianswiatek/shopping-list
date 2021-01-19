import ShoppingList_Domain

public struct RemoveItemsFromBasketCommand: Command {
    public let ids: [Id<Item>]
    public let source: CommandSource

    private let items: [Item]

    public init(_ items: [Item]) {
        self.ids = items.map { $0.id }
        self.items = items
        self.source = .basket
    }

    public func reversed() -> Command? {
        guard !items.isEmpty else { return nil }
        return RestoreItemsToBasketCommand(items)
    }
}
