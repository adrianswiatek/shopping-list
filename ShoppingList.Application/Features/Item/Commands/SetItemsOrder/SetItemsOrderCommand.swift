import ShoppingList_Domain

public struct SetItemsOrderCommand: Command {
    public let source: CommandSource

    internal let orderedIds: [Id<Item>]
    internal let listId: Id<List>

    public init(_ orderedIds: [Id<Item>], _ listId: Id<List>) {
        self.orderedIds = orderedIds
        self.listId = listId
        self.source = .items
    }
}
