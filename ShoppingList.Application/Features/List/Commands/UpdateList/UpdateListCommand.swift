import ShoppingList_Domain

public final class UpdateListCommand: Command {
    public let source: CommandSource

    internal let id: Id<List>
    internal let name: String

    public init(_ id: Id<List>, _ name: String) {
        self.id = id
        self.name = name
        self.source = .lists
    }
}
