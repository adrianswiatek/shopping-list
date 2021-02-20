import ShoppingList_Domain

public struct RestoreItemsCommand: Command {
    public let source: CommandSource

    internal let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
        self.source = .items
    }
}
