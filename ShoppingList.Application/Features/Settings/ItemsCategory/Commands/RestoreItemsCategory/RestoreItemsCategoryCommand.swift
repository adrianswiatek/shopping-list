import ShoppingList_Domain

public struct RestoreItemsCategoryCommand: Command {
    public let source: CommandSource

    internal let itemsCategory: ItemsCategory
    internal let itemIds: [Id<Item>]

    public init(_ itemsCategory: ItemsCategory, _ itemIds: [Id<Item>]) {
        self.itemsCategory = itemsCategory
        self.itemIds = itemIds
        self.source = .categories
    }
}
