import ShoppingList_Domain

public struct AddItemCommand: Command {
    public let source: CommandSource

    internal let name: String
    internal let info: String
    internal let categoryId: Id<ItemsCategory>
    internal let listId: Id<List>
    internal let externalUrl: String?

    public init(
        _ name: String,
        _ categoryId: Id<ItemsCategory>,
        _ listId: Id<List>,
        _ externalUrl: String?
    ) {
        self.init(name, "", categoryId, listId, externalUrl)
    }

    public init(
        _ name: String,
        _ info: String,
        _ categoryId: Id<ItemsCategory>,
        _ listId: Id<List>,
        _ externalUrl: String?
    ) {
        self.name = name
        self.info = info
        self.categoryId = categoryId
        self.listId = listId
        self.externalUrl = externalUrl
        self.source = .items
    }

    public static func withDefaultCategory(
        _ name: String,
        _ info: String,
        _ listId: Id<List>,
        _ externalUrl: String?
    ) -> AddItemCommand {
        .init(name, info, ItemsCategory.default.id, listId, externalUrl)
    }
}
