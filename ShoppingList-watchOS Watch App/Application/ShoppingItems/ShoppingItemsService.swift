final class ShoppingItemsService {
    private let repository: ShoppingItemsRepository

    init(repository: ShoppingItemsRepository) {
        self.repository = repository
    }

    func fetchItems(listId: Id<ShoppingList>) async -> [ShoppingItemViewModel] {
        await repository
            .fetch(listId)
            .map(ShoppingItemViewModel.fromShoppingItem)
            .sorted(using: ShoppingItemViewModel.NameSorter())
    }

    func moveItemToList(itemId: Id<ShoppingItem>) async {
        if let item = await repository.find(itemId) {
            await repository.update(item.updating(.state(to: .onList)))
        }
    }

    func moveItemToBasket(itemId: Id<ShoppingItem>) async {
        if let item = await repository.find(itemId) {
            await repository.update(item.updating(.state(to: .inBasket)))
        }
    }
}
