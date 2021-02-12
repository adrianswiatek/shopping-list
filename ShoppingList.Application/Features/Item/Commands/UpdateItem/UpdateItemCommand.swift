import ShoppingList_Domain

public struct UpdateItemCommand: Command {
    public let itemId: Id<Item>
    public let name: String
    public let info: String
    public let categoryId: Id<ItemsCategory>
    public let listId: Id<List>
    public let source: CommandSource

    public init(
        _ itemId: Id<Item>,
        _ name: String,
        _ info: String,
        _ categoryId: Id<ItemsCategory>,
        _ listId: Id<List>
    ) {
        self.itemId = itemId
        self.name = name
        self.info = info
        self.categoryId = categoryId
        self.listId = listId
        self.source = .items
    }
}
