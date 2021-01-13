import ShoppingList_Domain

public final class UpdateListCommand: Command {
    public let id: Id<List>
    public let name: String
    public let source: CommandSource

    public init(_ id: Id<List>, _ name: String) {
        self.id = id
        self.name = name
        self.source = .lists
    }
}
