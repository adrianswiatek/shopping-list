import ShoppingList_Domain

public struct UpdateItemCommand: Command {
    public let id: Id<Item>
    public let name: String
    public let info: String
    public let categoryId: Id<ItemsCategory>
    public let listId: Id<List>
    public let source: CommandSource

    public init(
        _ id: UUID,
        _ name: String,
        _ info: String,
        _ categoryUuid: UUID,
        _ listUuid: UUID
    ) {
        self.id = .fromUuid(id)
        self.name = name
        self.info = info
        self.categoryId = .fromUuid(categoryUuid)
        self.listId = .fromUuid(listUuid)
        self.source = .items
    }
}
