import ShoppingList_Domain

public struct RemoveListCommand: Command {
    public let source: CommandSource

    internal let list: List
    internal let items: [Item]

    public init(_ list: List) {
        self.init(list, [])
    }

    private init(_ list: List, _ items: [Item]) {
        self.list = list
        self.items = items
        self.source = .lists
    }

    public func reversed() -> Command? {
        RestoreListCommand(list, items)
    }

    internal func withItems(_ items: [Item]) -> Command {
        RemoveListCommand(list, items)
    }
}
