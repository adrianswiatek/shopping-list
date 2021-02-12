import ShoppingList_Domain

public struct AddItemCommand: Command {
    public let name: String
    public let info: String
    public let categoryId: Id<ItemsCategory>
    public let listId: Id<List>
    public let source: CommandSource

    public init(
        _ name: String,
        _ info: String,
        _ categoryId: Id<ItemsCategory>,
        _ listId: Id<List>
    ) {
        self.name = name
        self.info = info
        self.categoryId = categoryId
        self.listId = listId
        self.source = .items
    }

    public static func withDefaultCategory(
        _ name: String,
        _ info: String,
        _ listId: Id<List>
    ) -> AddItemCommand {
        .init(name, info, ItemsCategory.default.id, listId)
    }
}
