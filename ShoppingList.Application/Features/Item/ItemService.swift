import ShoppingList_Domain

public final class ItemService: ItemUseCases {
    private let itemRepository: ItemRepository

    public init(itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }
}
