import SwiftUI

extension ShoppingItemsView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published
        var itemsOnList: [ShoppingItemWithCategoryViewModel]

        @Published
        var itemsInBasket: [ShoppingItemViewModel]

        var listName: String {
            listViewModel.name
        }

        var hasItemsOnList: Bool {
            !itemsOnList.isEmpty
        }

        var hasItemsInBasket: Bool {
            !itemsInBasket.isEmpty
        }

        private let listViewModel: ShoppingListViewModel
        private let itemsService: ShoppingItemsService
        private let eventBus: EventBus

        init(
            list: ShoppingListViewModel,
            itemsService: ShoppingItemsService,
            eventBus: EventBus
        ) {
            self.listViewModel = list
            self.itemsService = itemsService
            self.eventBus = eventBus

            self.itemsOnList = []
            self.itemsInBasket = []

            self.bindEvents()
        }

        func fetchShoppingItems() async {
            let items = await itemsService.fetchItems(listId: .fromString(listViewModel.id))

            let itemsOnList = items.filter { !$0.inBasket }
            let itemsInBasket = items.filter { $0.inBasket }

            let categories = Set(itemsOnList.map(\.category)).sorted()

            self.itemsOnList = categories.map { category in
                .init(
                    category: category,
                    items: itemsOnList.filter { $0.category == category }
                )
            }
            self.itemsInBasket = itemsInBasket
        }

        func moveToList(_ itemId: String) async {
            await itemsService.moveItemToList(itemId: .fromString(itemId))
            await fetchShoppingItems()
        }

        func moveToBasket(_ itemId: String) async {
            await itemsService.moveItemToBasket(itemId: .fromString(itemId))
            await fetchShoppingItems()
        }

        private func bindEvents() {
            Task {
                for await event in eventBus.eventsPublisher.values where event == .modelUpdated {
                    await fetchShoppingItems()
                }
            }
        }
    }

    struct ShoppingItemWithCategoryViewModel: Identifiable {
        let category: String
        let items: [ShoppingItemViewModel]

        var id: String {
            category
        }
    }
}
