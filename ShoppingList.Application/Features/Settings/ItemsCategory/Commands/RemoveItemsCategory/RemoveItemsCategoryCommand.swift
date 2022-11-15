import ShoppingList_Domain

public struct RemoveItemsCategoryCommand: Command {
    public let source: CommandSource

    internal let itemsCategory: ItemsCategory
    internal let itemIds: [Id<Item>]

    public init(_ itemsCategory: ItemsCategory) {
        self.init(itemsCategory, [])
    }

    private init(_ itemsCategory: ItemsCategory, _ itemIds: [Id<Item>]) {
        self.itemsCategory = itemsCategory
        self.itemIds = itemIds
        self.source = .categories
    }

    public func reversed() -> Command? {
        RestoreItemsCategoryCommand(itemsCategory, itemIds)
    }

    internal func withItemIds(_ itemIds: [Id<Item>]) -> Command {
        RemoveItemsCategoryCommand(itemsCategory, itemIds)
    }
}
