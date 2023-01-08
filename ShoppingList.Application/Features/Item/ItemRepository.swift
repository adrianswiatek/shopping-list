import ShoppingList_Domain
import Combine

public protocol ItemRepository {
    func item(with id: Id<Item>) -> Item?

    func itemsInCategory(with id: Id<ItemsCategory>) -> [Item]
    func itemsWithState(_ state: ItemState, inListWithId id: Id<List>) -> [Item]
    func items(with ids: [Id<Item>]) -> [Item]

    func numberOfItemsWith(state: ItemState, inListWithId id: Id<List>) -> Int
    func numberOfItemsInList(with id: Id<List>) -> Int

    func addItems(_ items: [Item])

    func removeItems(with ids: [Id<Item>])
    func removeAll()

    func updateStateOfItems(with ids: [Id<Item>], to state: ItemState)
    func updateState(of item: Item, to state: ItemState)
    func updateItem(_ item: Item)
    func updateCategory(ofItem itemId: Id<Item>, toCategory categoryId: Id<ItemsCategory>)
    func updateCategoryOfItemsWithIds(_ itemIds: [Id<Item>], toCategory categoryId: Id<ItemsCategory>)

    func setItemsOrder(with itemIds: [Id<Item>], inListWithId listId: Id<List>, forState state: ItemState)
}
