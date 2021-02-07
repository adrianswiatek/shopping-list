import ShoppingList_Domain

public protocol ItemRepository {
    func item(with id: Id<Item>) -> Item?

    func itemsInCategory(_ category: ItemsCategory) -> [Item]
    func itemsWithState(_ state: ItemState, inListWithId id: Id<List>) -> [Item]
    func items(with ids: [Id<Item>]) -> [Item]

    func numberOfItemsWith(state: ItemState, inListWithId id: Id<List>) -> Int
    func numberOfItemsInList(with id: Id<List>) -> Int

    func addItems(_ items: [Item])
    func removeItems(with ids: [Id<Item>])

    func updateStateOfItems(with ids: [Id<Item>], to state: ItemState)
    func updateState(of item: Item, to state: ItemState)
    func updateItem(_ item: Item)
    func updateCategory(of item: Item, to category: ItemsCategory)
    func updateCategory(of items: [Item], to category: ItemsCategory)

    func setItemsOrder(with itemIds: [Id<Item>], inListWithId listId: Id<List>, forState state: ItemState)
}
