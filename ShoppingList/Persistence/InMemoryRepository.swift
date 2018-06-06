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
        let unorderedItems = items.filter { $0.state == state }
        let orderedItemsIds = itemsOrders.first { $0.itemsState == state }?.itemsIds ?? [UUID]()
        return ItemsSorter.sort(unorderedItems, by: orderedItemsIds)
    }
    
    func add(_ item: Item) {
        items.insert(item, at: 0)
    }
    
    func remove(_ items: [Item]) {
        items.forEach { remove($0) }
    }
    
    func remove(_ item: Item) {
        if let index = getIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        items.forEach { updateState(of: $0, to: state) }
    }
    
    func updateState(of item: Item, to state: ItemState) {
        if let index = getIndex(of: item) {
            items.remove(at: index)
            items.insert(item.getWithChanged(state: state), at: index)
        }
    }
    
    func updateCategory(of item: Item, to category: Category) {
        if let index = getIndex(of: item) {
            items.remove(at: index)
            items.insert(item.getWithChanged(category: category), at: index)
        }
    }
    
    func setItemsOrder(_ items: [Item], forState state: ItemState) {
        if let itemsOrderIndex = itemsOrders.index(where: { $0.itemsState == state }) {
            itemsOrders.remove(at: itemsOrderIndex)
        }
        
        guard items.count > 0 else { return }
        
        let itemsOrder = ItemsOrder(state, items)
        itemsOrders.append(itemsOrder)
    }
    
    func save() {}
    
    private func getIndex(of item: Item) -> Int? {
        return items.index { $0.id == item.id }
    }
}
