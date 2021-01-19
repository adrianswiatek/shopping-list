import ShoppingList_Domain

public struct ReclaimItemsCategoryCommand: Command {
    public let itemsCategory: ItemsCategory
    public let itemIds: [Id<Item>]
    public let source: CommandSource

    public init(_ itemsCategory: ItemsCategory, _ itemIds: [Id<Item>]) {
        self.itemsCategory = itemsCategory
        self.itemIds = itemIds
        self.source = .categories
    }
}
