import ShoppingList_Domain

public struct RemoveListCommand: Command {
    public let list: List
    public let source: CommandSource

    public init(_ list: List) {
        self.list = list
        self.source = .lists
    }

    public func reversed() -> Command? {
        AddListCommand(list.name)
    }
}
