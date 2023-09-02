import ShoppingList_Application
import ShoppingList_Domain

import Combine

public final class ManageItemsNamesViewModel: ViewModel, ObservableObject {
    @Published
    public var searchTerm: String

    @Published
    public var items: [ItemToSearchViewModel]

    @Published
    public var isEditItemNamePresented: Bool

    @Published
    public var editItemNameViewModel: EditItemNameViewModel

    public var canShowClearSearchTermButton: Bool {
        searchTerm.isEmpty == false
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.modelItems)
    }

    private var cancellables: Set<AnyCancellable>
    private var allItems: [ItemToSearchViewModel]

    private let modelItemQueries: ModelItemQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    public init(
        modelItemQueries: ModelItemQueries,
        commandBus: CommandBus,
        eventBus: EventBus
    ) {
        self.modelItemQueries = modelItemQueries
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.searchTerm = ""
        self.items = []
        self.isEditItemNamePresented = false
        self.editItemNameViewModel = .empty
        self.allItems = []

        self.cancellables = []

        self.fetchItems()

        self.bind()
    }

    public func confirmItemNameChange() {
        guard let item = editItemNameViewModel.item else {
            return
        }

        let itemId: Id<ModelItem> = .fromUuid(item.id)
        let currentName: String = item.name
        let newName: String = editItemNameViewModel.newName

        commandBus.execute(
            UpdateModelItemCommand(itemId, currentName, newName)
        )
    }

    public func showEditItem(_ item: ItemToSearchViewModel) {
        isEditItemNamePresented = true
        editItemNameViewModel = .fromItem(item)
    }

    public func clearSearchTerm() {
        searchTerm = ""
    }

    public func restore() {
        if commandBus.canUndo(.modelItems) {
            commandBus.undo(.modelItems)
        }
    }

    public func removeItemName(_ item: ItemToSearchViewModel) {
        commandBus.execute(
            RemoveModelItemCommand(.fromItemToSearch(item))
        )
    }

    private func fetchItems() {
        self.allItems = modelItemQueries
            .fetchModelItems()
            .map(ItemToSearchViewModel.Factory.fromModelItem)
        self.updateItems(withQuery: "")
    }

    private func updateItems(withQuery query: String) {
        let searchItems: (String, [ItemToSearchViewModel]) -> [ItemToSearchViewModel] = { query, items in
            query.isEmpty ? items : items.compactMap { $0.applyingQuery(query) }
        }
        items = searchItems(query, allItems).sorted()
    }

    private func bind() {
        eventBus.events
            .filterType(
                ModelItemAddedEvent.self,
                ModelItemRemovedEvent.self,
                ModelItemUpdatedEvent.self
            )
            .sink { [weak self] _ in self?.fetchItems() }
            .store(in: &cancellables)

        $searchTerm
            .sink { [weak self] in self?.updateItems(withQuery: $0) }
            .store(in: &cancellables)
    }
}

private extension ModelItem {
    static func fromItemToSearch(_ item: ItemToSearchViewModel) -> ModelItem {
        ModelItem(id: .fromUuid(item.id), name: item.name)
    }
}
