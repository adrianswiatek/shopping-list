import ShoppingList_Domain

public struct UpdateItemCommand: Command {
    public let source: CommandSource

    internal let itemId: Id<Item>
    internal let name: String
    internal let info: String
    internal let categoryId: Id<ItemsCategory>
    internal let listId: Id<List>
    internal let externalUrl: String?

    public init(
        _ itemId: Id<Item>,
        _ name: String,
        _ info: String,
        _ categoryId: Id<ItemsCategory>,
        _ listId: Id<List>,
        _ externalUrl: String?
    ) {
        self.itemId = itemId
        self.name = name
        self.info = info
        self.categoryId = categoryId
        self.listId = listId
        self.source = .items
        self.externalUrl = externalUrl
    }
}
