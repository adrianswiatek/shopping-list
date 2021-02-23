import ShoppingList_Domain

public struct AddItemCommand: Command {
    public let source: CommandSource

    internal let name: String
    internal let info: String
    internal let categoryId: Id<ItemsCategory>
    internal let listId: Id<List>

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
