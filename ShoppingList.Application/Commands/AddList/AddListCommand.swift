import ShoppingList_Domain

public struct AddListCommand: CommandNew {
    public let list: List
    public let source: CommandSource

    public init(_ list: List) {
        self.list = list
        self.source = .lists
    }

    public func reversed() -> CommandNew? {
        RemoveListCommand(list)
    }
}
