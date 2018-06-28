import Foundation

struct ItemsOrder {
    let itemsState: ItemState
    let listId: UUID
    let itemsIds: [UUID]
    
    init(_ itemsState: ItemState, _ list: List, _ itemsIds: [UUID]) {
        self.init(itemsState, list.id, itemsIds)
    }
    
    init(_ itemsState: ItemState, _ list: List, _ items: [Item]) {
        self.init(itemsState, list.id, items)
    }
    
    init(_ itemsState: ItemState, _ listId: UUID, _ itemsIds: [UUID]) {
        self.itemsState = itemsState
        self.listId = listId
        self.itemsIds = itemsIds
    }
    
    init(_ itemsState: ItemState, _ listId: UUID, _ items: [Item]) {
        self.itemsState = itemsState
        self.listId = listId
        self.itemsIds = items.map { $0.id }
    }
}
