public struct ItemsOrder {
    public let itemsState: ItemState
    public let listId: Id<List>
    public let itemsIds: [Id<Item>]
    
    public init(_ itemsState: ItemState, _ list: List, _ itemsIds: [Id<Item>]) {
        self.init(itemsState, list.id, itemsIds)
    }
    
    public init(_ itemsState: ItemState, _ list: List, _ items: [Item]) {
        self.init(itemsState, list.id, items)
    }
    
    public init(_ itemsState: ItemState, _ listId: Id<List>, _ itemsIds: [Id<Item>]) {
        self.itemsState = itemsState
        self.listId = listId
        self.itemsIds = itemsIds
    }
    
    public init(_ itemsState: ItemState, _ listId: Id<List>, _ items: [Item]) {
        self.itemsState = itemsState
        self.listId = listId
        self.itemsIds = items.map { $0.id }
    }
}
