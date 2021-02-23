import ShoppingList_Domain

public struct RestoreListCommand: Command {
    public let source: CommandSource

    internal let list: List
    internal let items: [Item]

    public init(_ list: List, _ items: [Item]) {
        self.list = list
        self.items = items
        self.source = .lists
    }
}
