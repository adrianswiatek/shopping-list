final class ShoppingListsService {
    private let listsRepository: ShoppingListsRepository
    private let itemsRepository: ShoppingItemsRepository

    init(
        listsRepository: ShoppingListsRepository,
        itemsRepository: ShoppingItemsRepository
    ) {
        self.listsRepository = listsRepository
        self.itemsRepository = itemsRepository
    }

    func fetchAllLists() async -> [ShoppingListViewModel] {
        await listsRepository
            .fetchAll()
            .map(ShoppingListViewModel.fromShoppingList)
            .sorted(using: ShoppingListViewModel.NameSorter())
    }

    func deleteList(withId listId: Id<ShoppingList>) async {
        await itemsRepository.delete(listId)
        await listsRepository.delete(listId)
    }
}
