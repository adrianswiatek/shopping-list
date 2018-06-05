import Foundation

struct ItemsOrder {
    let itemState: ItemState
    let itemsIds: [UUID]
    
    init(_ state: ItemState, _ items: [Item]) {
        self.itemState = state
        self.itemsIds = items.map { $0.id }
    }
}
