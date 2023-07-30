import ShoppingList_Domain

public struct SendListToWatchCommand: Command {
    public let source: CommandSource

    internal let listId: Id<List>

    public init(_ listId: Id<List>) {
        self.listId = listId
        self.source = .lists
    }
}
