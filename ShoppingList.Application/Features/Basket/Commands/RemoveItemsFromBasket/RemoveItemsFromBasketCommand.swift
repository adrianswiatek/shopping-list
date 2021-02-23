import ShoppingList_Domain

public struct RemoveItemsFromBasketCommand: Command {
    public let source: CommandSource

    internal let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
        self.source = .basket
    }

    public func reversed() -> Command? {
        !items.isEmpty ? RestoreItemsToBasketCommand(items) : nil
    }
}
