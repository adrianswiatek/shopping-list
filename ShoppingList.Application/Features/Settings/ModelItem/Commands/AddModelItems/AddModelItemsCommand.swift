import ShoppingList_Domain

public struct AddModelItemsCommand: Command {
    public let source: CommandSource

    internal let modelItems: [ModelItem]

    public init(_ modelItems: [ModelItem]) {
        self.modelItems = modelItems
        self.source = .modelItems
    }

    public init(_ items: [Item]) {
        self.init(items.map(ModelItem.newFromItem))
    }
}
