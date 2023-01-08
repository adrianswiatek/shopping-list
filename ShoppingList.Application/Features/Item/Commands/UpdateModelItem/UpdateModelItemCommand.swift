import ShoppingList_Domain

public struct UpdateModelItemCommand: Command {
    public let source: CommandSource

    internal let modelItemId: Id<ModelItem>
    internal let name: String
    internal let categoryId: Id<ItemsCategory>

    public init(_ modelItemId: Id<ModelItem>, _ name: String, _ categoryId: Id<ItemsCategory>) {
        self.modelItemId = modelItemId
        self.name = name
        self.categoryId = categoryId
        self.source = .modelItems
    }
}
