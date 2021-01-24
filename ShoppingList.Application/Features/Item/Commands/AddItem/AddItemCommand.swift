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
        _ categoryUuid: UUID,
        _ listUuid: UUID
    ) {
        self.name = name
        self.info = info
        self.categoryId = .fromUuid(categoryUuid)
        self.listId = .fromUuid(listUuid)
        self.source = .items
    }

    public static func withDefaultCategory(
        _ name: String,
        _ info: String,
        _ listUuid: UUID
    ) -> AddItemCommand {
        .init(name, info, ItemsCategory.default.id.toUuid(), listUuid)
    }
}
