import ShoppingList_Domain

public protocol ItemRepository {
    func getItems() -> [Item]
    func getItemsWith(state: ItemState, in list: List) -> [Item]
    func getNumberOfItemsWith(state: ItemState, in list: List) -> Int
    func getNumberOfItems(in list: List) -> Int
    func add(_ item: Item)
    func add(_ items: [Item])
    func remove(_ items: [Item])
    func remove(_ item: Item)
    func updateState(of items: [Item], to state: ItemState)
    func updateState(of item: Item, to state: ItemState)
    func update(_ item: Item)
    func updateCategory(of item: Item, to category: ItemsCategory)
    func updateCategory(of items: [Item], to category: ItemsCategory)
}
