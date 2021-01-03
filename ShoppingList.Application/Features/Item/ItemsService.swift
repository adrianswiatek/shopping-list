import ShoppingList_Domain

public final class ItemsService: ItemQueries {
    private let itemRepository: ItemRepository

    public init(itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func fetchItemsFromList(with id: Id<List>) -> [Item] {
        itemRepository.itemsWith(state: .toBuy, inListWithId: id)
    }

    public func hasItemsInBasketOfList(with id: Id<List>) -> Bool {
        itemRepository.numberOfItemsWith(state: .inBasket, inListWithId: id) > 0
    }
}
