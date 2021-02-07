import ShoppingList_Domain
import CoreData

extension ItemsOrderEntity {
    func map() -> ItemsOrder {
        guard let itemsState = ItemState(rawValue: Int(itemsState)) else {
            fatalError("Unable to create ItemsOrder")
        }
        
        guard let listId = listId else {
            fatalError("Unable to get list")
        }

        let itemIds: [Id<Item>]? = self.itemsIds
            .flatMap { try? JSONDecoder().decode([UUID].self, from: $0) }
            .map { $0.map { .fromUuid($0) } }

        return ItemsOrder(itemsState, .fromUuid(listId), itemIds ?? [])
    }
}
