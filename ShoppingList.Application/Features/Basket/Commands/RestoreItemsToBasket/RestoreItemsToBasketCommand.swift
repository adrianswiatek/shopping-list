import ShoppingList_Domain

public struct RestoreItemsToBasketCommand: Command {
    public let source: CommandSource

    internal let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
        self.source = .basket
    }
}
