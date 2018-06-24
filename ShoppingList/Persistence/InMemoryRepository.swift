import Foundation

class InMemoryRepository: RepositoryProtocol {

    private var lists = [List]()
    private var items = [Item]()
    private var itemsOrders = [ItemsOrder]()
    private var categories = [Category]()

    init() {
        let myList = List.new(name: "Daily shopping")
        
        let fruitsCategory = Category.new(name: "Fruits")
        categories.append(fruitsCategory)
        items.append(Item.toBuy(name: "Avocado", list: myList, category: fruitsCategory))
        items.append(Item.toBuy(name: "Bananas", list: myList, category: fruitsCategory))
        items.append(Item.toBuy(name: "Blackberries", list: myList, category: fruitsCategory))
        items.append(Item.toBuy(name: "Apples", list: myList, category: fruitsCategory))
        
        let dairyCategory = Category.new(name: "Dairy")
        categories.append(dairyCategory)
        items.append(Item.toBuy(name: "Milk", list: myList, category: dairyCategory))
        items.append(Item.toBuy(name: "Yogurt", list: myList, category: dairyCategory))
        
        let vegetablesCategory = Category.new(name: "Vegetables")
        categories.append(vegetablesCategory)
        items.append(Item.toBuy(name: "Carrots", list: myList, category: vegetablesCategory))
        items.append(Item.toBuy(name: "Spinach", list: myList, category: vegetablesCategory))
        items.append(Item.toBuy(name: "Kale", list: myList, category: vegetablesCategory))
        items.append(Item.toBuy(name: "Beetroot", list: myList, category: vegetablesCategory))
        
        let electronicsCategory = Category.new(name: "Electronics")
        categories.append(electronicsCategory)
        items.append(Item.toBuy(name: "iPad Gray 128GB 2018", list: myList, category: electronicsCategory))
        items.append(Item.toBuy(name: "Power adapter", list: myList, category: electronicsCategory))
        
        lists.append(myList.getWithChanged(items: items))
        lists.append(List.new(name: "For later"))
    }
    
    // MARK: - List
    
    func getLists() -> [List] {
        return lists
    }
    
    func add(_ list: List) {
        lists.append(list)
    }
    
    func update(_ list: List) {
        fatalError("Not implemented")
    }
    
    func remove(_ list: List) {
        guard let index = lists.index(where: { $0.id == list.id }) else {
            fatalError("Unable to find index of the given list.")
        }
        
        items.removeAll { $0.list.id == list.id }
        lists.remove(at: index)
    }
    
    // MARK: - Category
    
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
    
    // MARK: - Item
    
    func getItems() -> [Item] {
        return items
    }
    
    func getItemsFrom(list: List, withState state: ItemState) -> [Item] {
        return items.filter { $0.list.id == list.id }.filter { $0.state == state }
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
    
    // MARK: - Items Order
    
    func setItemsOrder(_ items: [Item], forState state: ItemState) {
        if let itemsOrderIndex = itemsOrders.index(where: { $0.itemsState == state }) {
            itemsOrders.remove(at: itemsOrderIndex)
        }
        
        guard items.count > 0 else { return }
        
        let itemsOrder = ItemsOrder(state, items)
        itemsOrders.append(itemsOrder)
    }
    
    // Mark: - Other
    
    func save() {}
    
    private func getIndex(of item: Item) -> Int? {
        return items.index { $0.id == item.id }
    }
    
    private func getIndex(of category: Category) -> Int? {
        return categories.index { $0.id == category.id }
    }
}
