import Foundation

class InMemoryRepository: RepositoryProtocol {
    
    private var items = [Item]()
    private var itemsOrders = [ItemsOrder]()
    
    init() {
        let fruitsCategory = Category.new(name: "Fruits")
        items.append(Item.toBuy(name: "Avocado", category: fruitsCategory))
        items.append(Item.toBuy(name: "Bananas", category: fruitsCategory))
        items.append(Item.toBuy(name: "Blackberries", category: fruitsCategory))
        items.append(Item.toBuy(name: "Apples", category: fruitsCategory))
        
        let dairyCategory = Category.new(name: "Dairy")
        items.append(Item.toBuy(name: "Milk", category: dairyCategory))
        items.append(Item.toBuy(name: "Yogurt", category: dairyCategory))
        
        let vegetablesCategory = Category.new(name: "Vegetables")
        items.append(Item.toBuy(name: "Carrots", category: vegetablesCategory))
        items.append(Item.toBuy(name: "Spinach", category: vegetablesCategory))
        items.append(Item.toBuy(name: "Kale", category: vegetablesCategory))
        items.append(Item.toBuy(name: "Beetroot", category: vegetablesCategory))
        
        let electronicsCategory = Category.new(name: "Electronics")
        items.append(Item.toBuy(name: "iPad Gray 128GB 2018", category: electronicsCategory))
        items.append(Item.toBuy(name: "Power adapter", category: electronicsCategory))
    }

    func getItemsWith(state: ItemState) -> [Item] {
        let itemsInGivenState = items.filter { $0.state == state }
        let itemsIds = itemsOrders.first { $0.itemState == state }?.itemsIds ?? [UUID]()
        return getItemsInOrder(items: itemsInGivenState, orderedItemsIds: itemsIds)
    }
    
    private func getItemsInOrder(items: [Item], orderedItemsIds: [UUID]) -> [Item] {
        var unorderedItems = items
        var result = [Item]()
        
        for itemId in orderedItemsIds {
            guard let itemIndex = unorderedItems.index(where: { $0.id == itemId }) else { continue }
            result.append(unorderedItems.remove(at: itemIndex))
        }
        
        unorderedItems.forEach { result.append($0) }
        return result
    }
    
    func add(_ item: Item) {
        items.insert(item, at: 0)
    }
    
    func remove(_ items: [Item]) {
        items.forEach { remove($0) }
    }
    
    func remove(_ item: Item) {
        if let index = self.items.index(where: { $0.id == item.id }) {
            self.items.remove(at: index)
        }
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        items.forEach { updateState(of: $0, to: state) }
    }
    
    func updateState(of item: Item, to state: ItemState) {
        if let index = self.items.index(where: { $0.id == item.id }) {
            self.items.remove(at: index)
            self.items.insert(item.getWithChanged(state: state), at: 0)
        }
    }
    
    func setItemsOrder(_ items: [Item], forState state: ItemState) {
        if let itemsOrderIndex = itemsOrders.index(where: { $0.itemState == state }) {
            itemsOrders.remove(at: itemsOrderIndex)
        }
        
        guard items.count > 0 else { return }
        
        let itemsOrder = ItemsOrder(state, items)
        itemsOrders.append(itemsOrder)
    }
    
    func save() {}
}
