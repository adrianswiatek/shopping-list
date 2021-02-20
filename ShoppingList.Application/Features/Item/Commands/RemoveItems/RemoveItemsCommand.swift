import ShoppingList_Domain

public struct RemoveItemsCommand: Command {
    public let source: CommandSource

    internal let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
        self.source = .items
    }

    public func reversed() -> Command? {
        !items.isEmpty ? RestoreItemsCommand(items) : nil
    }
}
