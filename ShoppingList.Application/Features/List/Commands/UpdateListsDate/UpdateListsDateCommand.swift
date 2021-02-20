import ShoppingList_Domain

public struct UpdateListsDateCommand: Command {
    public let source: CommandSource

    internal let id: Id<List>

    public init(_ id: Id<List>) {
        self.id = id
        self.source = .none
    }
}
