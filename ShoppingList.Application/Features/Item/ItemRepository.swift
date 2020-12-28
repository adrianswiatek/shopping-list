import ShoppingList_Domain

public protocol ItemRepository {
    func allItems() -> [Item]
    func itemsWith(state: ItemState, inListWithId listId: UUID) -> [Item]
    func items(in category: ItemsCategory) -> [Item]
    func numberOfItemsWith(state: ItemState, inListWithId listId: UUID) -> Int
    func numberOfItemsInList(with id: UUID) -> Int
    func add(_ item: Item)
    func add(_ items: [Item])
    func remove(_ items: [Item])
    func remove(_ item: Item)
    func updateState(of items: [Item], to state: ItemState)
    func updateState(of item: Item, to state: ItemState)
    func update(_ item: Item)
    func updateCategory(of item: Item, to category: ItemsCategory)
    func updateCategory(of items: [Item], to category: ItemsCategory)

    func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState)
}
