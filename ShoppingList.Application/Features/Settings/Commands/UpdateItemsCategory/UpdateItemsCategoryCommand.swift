import ShoppingList_Domain

public struct UpdateItemsCategoryCommand: Command {
    public let source: CommandSource

    internal let id: Id<ItemsCategory>
    internal let name: String

    public init(_ id: Id<ItemsCategory>, _ name: String) {
        self.id = id
        self.name = name
        self.source = .categories
    }
}
