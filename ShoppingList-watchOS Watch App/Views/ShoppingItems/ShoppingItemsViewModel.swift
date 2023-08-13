import SwiftUI

extension ShoppingItemsView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published
        var itemsOnListWithCategories: [ShoppingItemWithCategoryViewModel]

        @Published
        var itemsOnListWithoutCategories: [ShoppingItemViewModel]

        @Published
        var itemsInBasket: [ShoppingItemViewModel]

        var listName: String {
            listViewModel.name
        }

        var hasItemsOnList: Bool {
            !itemsOnListWithoutCategories.isEmpty
        }

        var hasItemsInBasket: Bool {
            !itemsInBasket.isEmpty
        }

        var listViewType: ListViewType {
            settingsService.showCategoriesOfItemsToBuy() ? .withCategories : .withoutCategories
        }

        private let listViewModel: ShoppingListViewModel
        private let itemsService: ShoppingItemsService
        private let settingsService: SettingsService
        private let eventBus: EventBus

        init(
            list: ShoppingListViewModel,
            itemsService: ShoppingItemsService,
            settingsService: SettingsService,
            eventBus: EventBus
        ) {
            self.listViewModel = list
            self.itemsService = itemsService
            self.settingsService = settingsService
            self.eventBus = eventBus

            self.itemsOnListWithCategories = []
            self.itemsOnListWithoutCategories = []
            self.itemsInBasket = []

            self.bindEvents()
        }

        func fetchShoppingItems() async {
            let items = await itemsService.fetchItems(listId: .fromString(listViewModel.id))

            self.itemsOnListWithCategories = prepareItemsOnListWithCategories(items)
            self.itemsOnListWithoutCategories = prepareItemsOnListWithoutCategories(items)
            self.itemsInBasket = prepareItemsInBasket(items)
        }

        private func prepareItemsOnListWithCategories(
            _ items: [ShoppingItemViewModel]
        ) -> [ShoppingItemWithCategoryViewModel] {
            let itemsOnList = items.filter { !$0.inBasket }
            let categories = Set(itemsOnList.map(\.category)).sorted()
            let comparator = Comparator(settingsService.listSortingOptions())

            return categories.map { category in
                ShoppingItemWithCategoryViewModel(
                    category: category,
                    items: itemsOnList.filter { $0.category == category }.sorted(using: comparator)
                )
            }
        }

        private func prepareItemsOnListWithoutCategories(
            _ items: [ShoppingItemViewModel]
        ) -> [ShoppingItemViewModel] {
            let comparator = Comparator(settingsService.listSortingOptions())
            return items.filter { $0.inBasket == false }.sorted(using: comparator)
        }

        private func prepareItemsInBasket(
            _ items: [ShoppingItemViewModel]
        ) -> [ShoppingItemViewModel] {
            let comparator = Comparator(settingsService.basketSortingOptions())
            return items.filter { $0.inBasket }.sorted(using: comparator)
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

    enum ListViewType {
        case withCategories
        case withoutCategories
    }

    struct ShoppingItemWithCategoryViewModel: Identifiable {
        let category: String
        let items: [ShoppingItemViewModel]

        var id: String {
            category
        }
    }

    struct Comparator: SortComparator {
        var algorithm: Algorithm
        var order: SortOrder

        init(_ options: Settings.ItemsSortingOptions) {
            self.algorithm = Algorithm(options.type)
            self.order = options.order == .ascending ? .forward : .reverse
        }

        func compare(
            _ lhs: ShoppingItemViewModel,
            _ rhs: ShoppingItemViewModel
        ) -> ComparisonResult {
            switch order {
            case .forward: return algorithm(lhs, rhs)
            case .reverse: return algorithm(rhs, lhs)
            }
        }

        struct Algorithm: Equatable, Hashable {
            private let sortingType: Settings.ItemsSortingType

            init (_ sortingType: Settings.ItemsSortingType) {
                self.sortingType = sortingType
            }

            private var alternativeAlgorithm: Algorithm {
                Algorithm(.alphabeticalOrder)
            }

            func callAsFunction(
                _ lhs: ShoppingItemViewModel,
                _ rhs: ShoppingItemViewModel
            ) -> ComparisonResult {
                switch sortingType {
                case .alphabeticalOrder:
                    return lhs.name.localizedCompare(rhs.name)
                case .updatingOrder:
                    let result = rhs.lastChange.compare(lhs.lastChange)
                    return result != .orderedSame ? result : alternativeAlgorithm(lhs, rhs)
                }
            }
        }
    }
}
