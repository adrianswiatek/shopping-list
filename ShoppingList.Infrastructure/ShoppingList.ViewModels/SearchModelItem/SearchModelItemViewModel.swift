import ShoppingList_Application

import Combine

public final class SearchModelItemViewModel: ObservableObject, ViewModel {
    @Published
    public var searchTerm: String

    @Published
    public var selectedItem: ItemToSearchViewModel?

    @Published
    public var items: [ItemToSearchViewModel]

    public var canShowClearSearchTermButton: Bool {
        searchTerm.isEmpty == false
    }

    private var cancellables: Set<AnyCancellable>
    private var allItems: [ItemToSearchViewModel]

    private let modelItemQueries: ModelItemQueries

    public init(modelItemQueries: ModelItemQueries) {
        self.modelItemQueries = modelItemQueries

        self.searchTerm = ""
        self.selectedItem = nil
        self.items = []
        self.allItems = []
        self.cancellables = []

        self.fetchItems()

        self.bind()
    }

    public func clearSearchTerm() {
        searchTerm = ""
    }

    private func fetchItems() {
        self.allItems = modelItemQueries
            .fetchModelItems()
            .map(ItemToSearchViewModel.init)
        self.updateItems(withQuery: "")
    }

    private func updateItems(withQuery query: String) {
        let searchItems: (String, [ItemToSearchViewModel]) -> [ItemToSearchViewModel] = { query, items in
            query.isEmpty ? items : items.compactMap { $0.applyingQuery(query) }
        }
        items = searchItems(query, allItems).sorted()
    }

    private func bind() {
        $searchTerm
            .sink { [weak self] in
                self?.updateItems(withQuery: $0)
            }
            .store(in: &cancellables)
    }
}
