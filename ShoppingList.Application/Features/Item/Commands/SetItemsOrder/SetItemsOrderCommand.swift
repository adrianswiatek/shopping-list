import ShoppingList_Domain

public struct SetItemsOrderCommand: Command {
    public let orderedIds: [Id<Item>]
    public let listId: Id<List>
    public let source: CommandSource

    public init(_ orderedIds: [Id<Item>], _ listId: Id<List>) {
        self.orderedIds = orderedIds
        self.listId = listId
        self.source = .items
    }
}
