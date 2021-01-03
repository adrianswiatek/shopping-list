import ShoppingList_Domain

public struct UpdateItemsCategoryCommand: CommandNew {
    public let id: Id<Category>
    public let name: String
    public let source: CommandSource

    public init(_ id: Id<Category>, _ name: String) {
        self.id = id
        self.name = name
        self.source = .categories
    }
}
