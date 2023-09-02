import ShoppingList_Domain

public struct UpdateModelItemCommand: Command {
    public let source: CommandSource

    internal let modelItemId: Id<ModelItem>
    internal let currentName: String
    internal let newName: String

    public init(_ modelItemId: Id<ModelItem>, _ currentName: String, _ newName: String) {
        self.modelItemId = modelItemId
        self.currentName = currentName
        self.newName = newName
        self.source = .modelItems
    }

    public func reversed() -> Command? {
        UpdateModelItemCommand(modelItemId, newName, currentName)
    }
}
