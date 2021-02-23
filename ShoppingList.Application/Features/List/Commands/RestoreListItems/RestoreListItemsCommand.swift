import ShoppingList_Domain

public struct RestoreListItemsCommand: Command {
    public let source: CommandSource

    internal let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
        self.source = .lists
    }
}
