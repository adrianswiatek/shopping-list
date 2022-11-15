import ShoppingList_Domain

public struct RemoveModelItemCommand: Command {
    public let source: CommandSource

    internal let modelItem: ModelItem

    public init(_ modelItem: ModelItem) {
        self.modelItem = modelItem
        self.source = .modelItems
    }
}
