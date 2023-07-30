@MainActor
final class ViewModelsFactory {
    private let container: Container

    init(container: Container) {
        self.container = container
    }

    func shopingItems(_ list: ShoppingListViewModel) -> ShoppingItemsView.ViewModel {
        ShoppingItemsView.ViewModel(
            list: list,
            itemsService: container.resolve(),
            eventBus: container.resolve()
        )
    }

    func shoppingLists() -> ShoppingListsView.ViewModel {
        ShoppingListsView.ViewModel(
            listsService: container.resolve(),
            eventBus: container.resolve()
        )
    }
}
