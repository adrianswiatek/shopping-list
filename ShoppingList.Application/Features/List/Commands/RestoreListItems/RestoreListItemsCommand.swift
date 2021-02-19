import ShoppingList_Domain

public struct RestoreListItemsCommand: Command {
    public let items: [Item]
    public let source: CommandSource

    public init(_ items: [Item]) {
        self.items = items
        self.source = .lists
    }
}
