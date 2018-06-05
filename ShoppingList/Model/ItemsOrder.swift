import Foundation

struct ItemsOrder {
    let itemsState: ItemState
    let itemsIds: [UUID]
    
    init(_ itemsState: ItemState, _ itemsIds: [UUID]) {
        self.itemsState = itemsState
        self.itemsIds = itemsIds
    }
    
    init(_ itemsState: ItemState, _ items: [Item]) {
        self.itemsState = itemsState
        self.itemsIds = items.map { $0.id }
    }
}
