import ShoppingList_Application

import Combine

public final class SelectItemsCategoryViewModel: ObservableObject {
    @Published
    public var categories: [ItemsCategoryViewModel]

    @Published
    public var selectedCategory: ItemsCategoryViewModel?

    private var cancellables: Set<AnyCancellable>
    private let itemsCategoryQueries: ItemsCategoryQueries

    public init(_ itemsCategoryQueries: ItemsCategoryQueries) {
        self.itemsCategoryQueries = itemsCategoryQueries

        self.categories = []
        self.cancellables = []

        self.fetchCategories()
    }

    public func selectDefaultCategory() {
        selectedCategory = categories.first { $0.isDefault }
    }

    private func fetchCategories() {
        categories = itemsCategoryQueries
            .fetchCategories()
            .map(ItemsCategoryViewModel.init)
    }
}
