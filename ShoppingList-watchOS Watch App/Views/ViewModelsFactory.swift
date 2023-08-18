@MainActor
final class ViewModelsFactory {
    private let container: Container

    nonisolated init(container: Container) {
        self.container = container
    }

    func shopingItems(_ list: ShoppingListViewModel) -> ShoppingItemsView.ViewModel {
        ShoppingItemsView.ViewModel(
            list: list,
            itemsService: container.resolve(),
            listsService: container.resolve(),
            settingsService: container.resolve(),
            eventsBus: container.resolve()
        )
    }

    func shoppingLists() -> ShoppingListsView.ViewModel {
        ShoppingListsView.ViewModel(
            listsService: container.resolve(),
            eventsBus: container.resolve()
        )
    }

    func settings() -> SettingsView.ViewModel {
        SettingsView.ViewModel(
            settingsService: container.resolve()
        )
    }
}
