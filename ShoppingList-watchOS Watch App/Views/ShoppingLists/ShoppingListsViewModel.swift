import SwiftUI

extension ShoppingListsView {

    @MainActor
    final class ViewModel: ObservableObject {
        @Published
        var lists: [ShoppingListViewModel]

        var hasLists: Bool {
            !lists.isEmpty
        }

        private let listsService: ShoppingListsService
        private let eventBus: EventBus

        init(
            listsService: ShoppingListsService,
            eventBus: EventBus
        ) {
            self.listsService = listsService
            self.eventBus = eventBus

            self.lists = []

            self.bindEvents()
        }

        func fetchShoppingLists() async {
            lists = await listsService.fetchAllLists()
        }

        func deleteList(_ indexSet: IndexSet) async {
            let listId = indexSet.first
                .map { lists[$0].id }
                .map(Id<ShoppingList>.fromString)

            guard let listId else { return }

            await listsService.deleteList(withId: listId)
            await fetchShoppingLists()
        }

        private func bindEvents() {
            Task {
                for await event in eventBus.eventsPublisher.values where event == .modelUpdated {
                    await fetchShoppingLists()
                }
            }
        }
    }
}
