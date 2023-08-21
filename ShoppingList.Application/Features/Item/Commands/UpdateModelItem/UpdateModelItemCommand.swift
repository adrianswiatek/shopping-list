import ShoppingList_Domain

public struct UpdateModelItemCommand: Command {
    public let source: CommandSource

    internal let modelItemId: Id<ModelItem>
    internal let name: String

    public init(_ modelItemId: Id<ModelItem>, _ name: String) {
        self.modelItemId = modelItemId
        self.name = name
        self.source = .modelItems
    }
}
