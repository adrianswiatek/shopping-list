import ShoppingList_Domain

public struct ClearListCommand: Command {
    public let id: Id<List>
    public let source: CommandSource

    public init(_ id: Id<List>) {
        self.id = id
        self.source = .lists
    }
}
