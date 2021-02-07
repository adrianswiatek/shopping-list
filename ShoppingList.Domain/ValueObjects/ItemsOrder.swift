public struct ItemsOrder {
    public let itemsState: ItemState
    public let listId: Id<List>
    public let itemsIds: [Id<Item>]

    public init(_ itemsState: ItemState, _ listId: Id<List>, _ itemsIds: [Id<Item>]) {
        self.itemsState = itemsState
        self.listId = listId
        self.itemsIds = itemsIds
    }
}
