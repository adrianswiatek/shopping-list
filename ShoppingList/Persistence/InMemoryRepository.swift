import Foundation

class InMemoryRepository: RepositoryProtocol {

    private var lists = [List]()
    private var itemsOrders = [ItemsOrder]()
    private var categories = [Category]()
    
    

    init() {
        var myList = List.new(name: "Daily shopping")
        
        let fruitsCategory = Category.new(name: "Fruits")
        categories.append(fruitsCategory)
        myList = myList.getWithAdded(item: Item.toBuy(name: "Avocado", description: "", list: myList, category: fruitsCategory))
        myList = myList.getWithAdded(item: Item.toBuy(name: "Bananas", description: "", list: myList, category: fruitsCategory))
        myList = myList.getWithAdded(item: Item.toBuy(name: "Blackberries", description: "", list: myList, category: fruitsCategory))
        myList = myList.getWithAdded(item: Item.toBuy(name: "Apples", description: "", list: myList, category: fruitsCategory))
        
        let dairyCategory = Category.new(name: "Dairy")
        categories.append(dairyCategory)
        myList = myList.getWithAdded(item: Item.toBuy(name: "Milk", description: "", list: myList, category: dairyCategory))
        myList = myList.getWithAdded(item: Item.toBuy(name: "Yogurt", description: "", list: myList, category: dairyCategory))
        
        let vegetablesCategory = Category.new(name: "Vegetables")
        categories.append(vegetablesCategory)
        myList = myList.getWithAdded(item: Item.toBuy(name: "Carrots", description: "", list: myList, category: vegetablesCategory))
        myList = myList.getWithAdded(item: Item.toBuy(name: "Spinach", description: "", list: myList, category: vegetablesCategory))
        myList = myList.getWithAdded(item: Item.toBuy(name: "Kale", description: "", list: myList, category: vegetablesCategory))
        myList = myList.getWithAdded(item: Item.toBuy(name: "Beetroot", description: "", list: myList, category: vegetablesCategory))
        
        let electronicsCategory = Category.new(name: "Electronics")
        categories.append(electronicsCategory)
        myList = myList.getWithAdded(item: Item.toBuy(name: "iPad Gray 128GB 2018", description: "", list: myList, category: electronicsCategory))
        myList = myList.getWithAdded(item: Item.toBuy(name: "Power adapter", description: "", list: myList, category: electronicsCategory))
        
        lists.append(myList)
        lists.append(List.new(name: "For later"))
    }
    
    // MARK: - List
    
    func getLists() -> [List] {
        return lists
    }
    
    func getList(by id: UUID) -> List? {
        return lists.first { $0.id == id }
    }
    
    func add(_ list: List) {
        lists.append(list)
    }
    
    func update(_ list: List) {
        guard let index = getIndex(of: list) else {
            fatalError("Unable to find index of the given list.")
        }
        
        lists.remove(at: index)
        lists.insert(list, at: index)
    }
    
    func remove(_ list: List) {
        guard let index = getIndex(of: list) else {
            fatalError("Unable to find index of the given list.")
        }
        
        lists.remove(at: index)
        itemsOrders.removeAll { $0.listId == list.id }
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
            
            let itemsInCategory = lists
                .flatMap { $0.items }
                .filter { $0.getCategoryName() == removedCategory.name }
            
            updateCategory(of: itemsInCategory, to: category)
        }
    }
    
    func remove(_ category: Category) {
        if let index = getIndex(of: category) {
            let removedCategory = categories.remove(at: index)
            
            let itemsInCategory = lists
                .flatMap { $0.items }
                .filter { $0.getCategoryName() == removedCategory.name }
            
            updateCategory(of: itemsInCategory, to: Category.getDefault())
        }
    }
    
    // MARK: - Item
    
    func getItems() -> [Item] {
        return lists.flatMap { $0.items }
    }
    
    func getItemsWith(state: ItemState, in list: List) -> [Item] {
        guard let indexOfList = getIndex(of: list) else { return [] }
        
        let unorderedItems = lists[indexOfList].items.filter { $0.state == state }
        let orderedItemsIds = itemsOrders
            .filter { $0.listId == list.id }
            .first { $0.itemsState == state }?
            .itemsIds
        
        return ItemsSorter.sort(unorderedItems, by: orderedItemsIds ?? [UUID]())
    }
    
    func getNumberOfItemsWith(state: ItemState, in list: List) -> Int {
        guard let indexOfList = getIndex(of: list) else { return 0 }
        
        return lists[indexOfList].items.filter { $0.state == state }.count
    }
    
    func getNumberOfItems(in list: List) -> Int {
        guard let indexOfList = getIndex(of: list) else { return 0 }
        return lists[indexOfList].items.count
    }
    
    func add(_ item: Item) {
        guard let indexOfList = getIndex(of: item.list) else { return }
        update(lists[indexOfList].getWithAdded(item: item))
    }
    
    func remove(_ items: [Item]) {
        items.forEach { remove($0) }
    }
    
    func remove(_ item: Item) {
        guard let indexOfList = getIndex(of: item.list) else { return }
        update(lists[indexOfList].getWithRemoved(item: item))
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        items.forEach { updateState(of: $0, to: state) }
    }
    
    func updateState(of item: Item, to state: ItemState) {
        guard let indexOfList = getIndex(of: item.list) else { return}
        
        let updatedItem = item.getWithChanged(state: state)
        update(lists[indexOfList].getWithChanged(item: updatedItem))
    }
    
    func update(_ item: Item) {
        guard let indexOfList = getIndex(of: item.list) else { return}
        
        update(lists[indexOfList].getWithChanged(item: item))
    }
    
    func updateCategory(of item: Item, to category: Category) {
        guard let indexOfList = getIndex(of: item.list) else { return}
        
        let updatedItem = item.getWithChanged(category: category)
        update(lists[indexOfList].getWithChanged(item: updatedItem))
    }
    
    func updateCategory(of items: [Item], to category: Category) {
        for item in items {
            updateCategory(of: item, to: category)
        }
    }
    
    // MARK: - Items Order
    
    func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState) {
        if let itemsOrderIndex = itemsOrders.index(where: { $0.listId == list.id && $0.itemsState == state }) {
            itemsOrders.remove(at: itemsOrderIndex)
        }
        
        guard items.count > 0 else { return }
        
        let itemsOrder = ItemsOrder(state, list.id, items)
        itemsOrders.append(itemsOrder)
    }
    
    // Mark: - Other
    
    func save() {}
    
    private func getIndex(of item: Item, in list: List) -> Int? {
        guard let indexOfList = getIndex(of: list) else { return nil }
        return lists[indexOfList].items.index { $0.id == item.id }
    }
    
    private func getIndex(of category: Category) -> Int? {
        return categories.index { $0.id == category.id }
    }
    
    private func getIndex(of list: List) -> Int? {
        return lists.index { $0.id == list.id }
    }
}
