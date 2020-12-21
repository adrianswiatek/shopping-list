import ShoppingList_Domain

public struct RemoveItemsCategoryCommand: CommandNew {
    public let itemsCategory: ItemsCategory
    public let source: CommandSource

    public init(_ itemsCategory: ItemsCategory) {
        self.itemsCategory = itemsCategory
        self.source = .categories
    }

    public func reversed() -> CommandNew? {
        AddItemsCategoryCommand(itemsCategory.name)
    }
}
