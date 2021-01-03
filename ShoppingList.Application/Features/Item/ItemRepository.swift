import ShoppingList_Domain

public protocol ItemRepository {
    func allItems() -> [Item]
    func itemsWith(state: ItemState, inListWithId id: Id<List>) -> [Item]
    func items(in category: ItemsCategory) -> [Item]
    func numberOfItemsWith(state: ItemState, inListWithId id: Id<List>) -> Int
    func numberOfItemsInList(with id: Id<List>) -> Int
    func add(_ item: Item)
    func add(_ items: [Item])
    func remove(_ items: [Item])
    func remove(_ item: Item)
    func updateStateOfItems(with ids: [Id<Item>], to state: ItemState)
    func updateState(of item: Item, to state: ItemState)
    func update(_ item: Item)
    func updateCategory(of item: Item, to category: ItemsCategory)
    func updateCategory(of items: [Item], to category: ItemsCategory)

    func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState)
}
