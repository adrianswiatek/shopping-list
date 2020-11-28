import ShoppingList_Domain
import Foundation

final class InMemoryRepository: RepositoryProtocol {
    private var lists = [List]()
    private var itemsOrders = [ItemsOrder]()
    private var categories = [ItemsCategory]()
    
    init() {
        var myList: List = .withName("Daily shopping")
        
        let fruitsCategory: ItemsCategory = .withName("Fruits")
        categories.append(fruitsCategory)
        myList = myList.withAddedItem(.toBuy(name: "Avocado", info: "", list: myList, category: fruitsCategory))
        myList = myList.withAddedItem(.toBuy(name: "Bananas", info: "", list: myList, category: fruitsCategory))
        myList = myList.withAddedItem(.toBuy(name: "Blackberries", info: "", list: myList, category: fruitsCategory))
        myList = myList.withAddedItem(.toBuy(name: "Apples", info: "", list: myList, category: fruitsCategory))
        
        let dairyCategory: ItemsCategory = .withName("Dairy")
        categories.append(dairyCategory)
        myList = myList.withAddedItem(.toBuy(name: "Milk", info: "", list: myList, category: dairyCategory))
        myList = myList.withAddedItem(.toBuy(name: "Yogurt", info: "", list: myList, category: dairyCategory))
        
        let vegetablesCategory: ItemsCategory = .withName("Vegetables")
        categories.append(vegetablesCategory)
        myList = myList.withAddedItem(.toBuy(name: "Carrots", info: "", list: myList, category: vegetablesCategory))
        myList = myList.withAddedItem(.toBuy(name: "Spinach", info: "", list: myList, category: vegetablesCategory))
        myList = myList.withAddedItem(.toBuy(name: "Kale", info: "", list: myList, category: vegetablesCategory))
        myList = myList.withAddedItem(.toBuy(name: "Beetroot", info: "", list: myList, category: vegetablesCategory))
        
        let electronicsCategory: ItemsCategory = .withName("Electronics")
        categories.append(electronicsCategory)
        myList = myList.withAddedItem(.toBuy(name: "iPad Gray 128GB 2018", info: "", list: myList, category: electronicsCategory))
        myList = myList.withAddedItem(.toBuy(name: "Power adapter", info: "", list: myList, category: electronicsCategory))
        
        lists.append(myList)
        lists.append(.withName("For later"))
    }
    
    // MARK: - List
    
    func getLists() -> [List] {
        lists
    }
    
    func getList(by id: UUID) -> List? {
        lists.first { $0.id == id }
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
    
    func getCategories() -> [ItemsCategory] {
        categories
    }
    
    func add(_ category: ItemsCategory) {
        categories.append(category)
    }

    func update(_ category: ItemsCategory) {
        if let index = getIndex(of: category) {
            let removedCategory = categories.remove(at: index)
            categories.insert(category, at: index)
            
            let itemsInCategory = lists
                .flatMap { $0.items }
                .filter { $0.categoryName() == removedCategory.name }
            
            updateCategory(of: itemsInCategory, to: category)
        }
    }
    
    func remove(_ category: ItemsCategory) {
        if let index = getIndex(of: category) {
            let removedCategory = categories.remove(at: index)
            
            let itemsInCategory = lists
                .flatMap { $0.items }
                .filter { $0.categoryName() == removedCategory.name }
            
            updateCategory(of: itemsInCategory, to: ItemsCategory.default)
        }
    }
    
    // MARK: - Item
    
    func getItems() -> [Item] {
        lists.flatMap { $0.items }
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
        update(lists[indexOfList].withAddedItem(item))
    }
    
    func add(_ items: [Item]) {
        items.forEach { [weak self] in self?.add($0) }
    }
    
    func remove(_ items: [Item]) {
        items.forEach { remove($0) }
    }
    
    func remove(_ item: Item) {
        guard let indexOfList = getIndex(of: item.list) else { return }
        update(lists[indexOfList].withRemovedItem(item))
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        items.forEach { updateState(of: $0, to: state) }
    }
    
    func updateState(of item: Item, to state: ItemState) {
        guard let indexOfList = getIndex(of: item.list) else { return}
        
        let updatedItem = item.getWithChanged(state: state)
        update(lists[indexOfList].withChangedItem(updatedItem))
    }
    
    func update(_ item: Item) {
        guard let indexOfList = getIndex(of: item.list) else { return}
        update(lists[indexOfList].withChangedItem(item))
    }
    
    func updateCategory(of item: Item, to category: ItemsCategory) {
        guard let indexOfList = getIndex(of: item.list) else { return}
        
        let updatedItem = item.getWithChanged(category: category)
        update(lists[indexOfList].withChangedItem(updatedItem))
    }
    
    func updateCategory(of items: [Item], to category: ItemsCategory) {
        items.forEach { updateCategory(of: $0, to: category) }
    }
    
    // MARK: - Items Order
    
    func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState) {
        if let itemsOrderIndex = itemsOrders.firstIndex(where: { $0.listId == list.id && $0.itemsState == state }) {
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
        return lists[indexOfList].items.firstIndex { $0.id == item.id }
    }
    
    private func getIndex(of category: ItemsCategory) -> Int? {
        categories.firstIndex { $0.id == category.id }
    }
    
    private func getIndex(of list: List) -> Int? {
        lists.firstIndex { $0.id == list.id }
    }
}
