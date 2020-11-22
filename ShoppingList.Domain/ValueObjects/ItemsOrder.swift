import Foundation

public struct ItemsOrder {
    public let itemsState: ItemState
    public let listId: UUID
    public let itemsIds: [UUID]
    
    public init(_ itemsState: ItemState, _ list: List, _ itemsIds: [UUID]) {
        self.init(itemsState, list.id, itemsIds)
    }
    
    public init(_ itemsState: ItemState, _ list: List, _ items: [Item]) {
        self.init(itemsState, list.id, items)
    }
    
    public init(_ itemsState: ItemState, _ listId: UUID, _ itemsIds: [UUID]) {
        self.itemsState = itemsState
        self.listId = listId
        self.itemsIds = itemsIds
    }
    
    public init(_ itemsState: ItemState, _ listId: UUID, _ items: [Item]) {
        self.itemsState = itemsState
        self.listId = listId
        self.itemsIds = items.map { $0.id }
    }
}
