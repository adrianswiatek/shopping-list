import Foundation

class InMemoryRepository: RepositoryProtocol {
    
    private var items = [Item]()
    private var itemsOrders = [ItemsOrder]()
    private var categories = [Category]()
    
    init() {
        let fruitsCategory = Category.new(name: "Fruits")
        categories.append(fruitsCategory)
        items.append(Item.toBuy(name: "Avocado", category: fruitsCategory))
        items.append(Item.toBuy(name: "Bananas", category: fruitsCategory))
        items.append(Item.toBuy(name: "Blackberries", category: fruitsCategory))
        items.append(Item.toBuy(name: "Apples", category: fruitsCategory))
        
        let dairyCategory = Category.new(name: "Dairy")
        categories.append(dairyCategory)
        items.append(Item.toBuy(name: "Milk", category: dairyCategory))
        items.append(Item.toBuy(name: "Yogurt", category: dairyCategory))
        
        let vegetablesCategory = Category.new(name: "Vegetables")
        categories.append(vegetablesCategory)
        items.append(Item.toBuy(name: "Carrots", category: vegetablesCategory))
        items.append(Item.toBuy(name: "Spinach", category: vegetablesCategory))
        items.append(Item.toBuy(name: "Kale", category: vegetablesCategory))
        items.append(Item.toBuy(name: "Beetroot", category: vegetablesCategory))
        
        let electronicsCategory = Category.new(name: "Electronics")
        categories.append(electronicsCategory)
        items.append(Item.toBuy(name: "iPad Gray 128GB 2018", category: electronicsCategory))
        items.append(Item.toBuy(name: "Power adapter", category: electronicsCategory))
        
        categories.append(Category.getDefault())
        categories.append(Category.new(name: "Dupa"))
    }
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func add(_ category: Category) {
        categories.append(category)
    }

    func update(_ category: Category) {
        if let index = getIndex(of: category) {
            let removedCategory = categories.remove(at: index)
            categories.insert(category, at: index)
            
            let itemsInCategory = items.filter { $0.getCategoryName() == removedCategory.name }
            updateCategory(of: itemsInCategory, to: category)
        }
    }
    
    func remove(_ category: Category) {
        if let index = getIndex(of: category) {
            let removedCategory = categories.remove(at: index)
            
            let itemsInCategory = items.filter { $0.getCategoryName() == removedCategory.name }
            updateCategory(of: itemsInCategory, to: Category.getDefault())
        }
    }
    
    func getItems() -> [Item] {
        return items
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
    
    func update(_ item: Item) {
        if let index = getIndex(of: item) {
            items.remove(at: index)
            items.insert(item, at: index)
        }
    }
    
    func updateCategory(of item: Item, to category: Category) {
        if let index = getIndex(of: item) {
            items.remove(at: index)
            items.insert(item.getWithChanged(category: category), at: index)
        }
    }
    
    func updateCategory(of items: [Item], to category: Category) {
        for item in items {
            updateCategory(of: item, to: category)
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
    
    private func getIndex(of category: Category) -> Int? {
        return categories.index { $0.id == category.id }
    }
}
