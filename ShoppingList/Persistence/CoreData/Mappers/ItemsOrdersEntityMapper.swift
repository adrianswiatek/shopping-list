import CoreData

extension ItemsOrderEntity {
    func map() -> ItemsOrder {
        guard let itemsState = ItemState(rawValue: Int(self.itemsState)) else {
            fatalError("Unable to create ItemsOrder")
        }
        
        if let itemsIdsData = self.itemsIds,
            let itemsIds = try? JSONDecoder().decode([UUID].self, from: itemsIdsData) {
            return ItemsOrder(itemsState, itemsIds)
        }
        
        return ItemsOrder(itemsState, [Item]())
    }
}

extension ItemsOrder {
    func map(context: NSManagedObjectContext) -> ItemsOrderEntity {
        let entity = ItemsOrderEntity(context: context)
        entity.itemsState = Int32(self.itemsState.rawValue)
        
        if let itemsIdsData = try? JSONEncoder().encode(self.itemsIds) {
            entity.itemsIds = itemsIdsData
        }
        
        return entity
    }
}
