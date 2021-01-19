import ShoppingList_Domain

public final class ItemsService: ItemQueries {
    private let itemRepository: ItemRepository

    public init(itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func fetchItemsToBuyFromList(with id: Id<List>) -> [Item] {
        itemRepository.itemsWithState(.toBuy, inListWithId: id)
    }

    public func fetchItemsInBasketFromList(with id: Id<List>) -> [Item] {
        itemRepository.itemsWithState(.inBasket, inListWithId: id)
    }

    public func fetchItemsInCategory(_ category: ItemsCategory) -> [Item] {
        itemRepository.itemsInCategory(category)
    }

    public func hasItemsInBasketOfList(with id: Id<List>) -> Bool {
        itemRepository.numberOfItemsWith(state: .inBasket, inListWithId: id) > 0
    }
}
