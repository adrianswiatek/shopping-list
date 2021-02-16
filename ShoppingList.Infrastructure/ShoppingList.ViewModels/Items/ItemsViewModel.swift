import ShoppingList_Domain
import ShoppingList_Application
import Combine

public final class ItemsViewModel: ViewModel {
    public private(set) var list: ListViewModel!

    public var sectionsPublisher: AnyPublisher<[ItemsSectionViewModel], Never> {
        sectionsSubject.eraseToAnyPublisher()
    }

    public var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    public var itemsMovedPublisher: AnyPublisher<(fromSection: Int, toSection: Int), Never> {
        itemsMovedSubject.eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabledPublisher: AnyPublisher<Bool, Never> {
        isRestoreButtonEnabledSubject.eraseToAnyPublisher()
    }

    public var hasItemsInTheBasketPublisher: AnyPublisher<Bool, Never> {
        sectionsSubject
            .map { [weak self] _ in self?.hasItemsInBasket() == true }
            .eraseToAnyPublisher()
    }

    public var canShareItems: Bool {
        sectionsSubject.value.first { !$0.items.isEmpty } != nil
    }

    private let sectionsSubject: CurrentValueSubject<[ItemsSectionViewModel], Never>
    private let stateSubject: CurrentValueSubject<State, Never>
    private let itemsMovedSubject: PassthroughSubject<(fromSection: Int, toSection: Int), Never>
    private let isRestoreButtonEnabledSubject: CurrentValueSubject<Bool, Never>
    private var cancellables: Set<AnyCancellable>

    private let expectedEventTypes: [Event.Type]

    private let itemQueries: ItemQueries
    private let categoryQuries: ItemsCategoryQueries
    private let sharedItemsFormatter: SharedItemsFormatter
    private let commandBus: CommandBus
    private let eventBus: EventBus

    public init(
        itemQueries: ItemQueries,
        categoryQuries: ItemsCategoryQueries,
        sharedItemsFormatter: SharedItemsFormatter,
        commandBus: CommandBus,
        eventBus: EventBus
    ) {
        self.itemQueries = itemQueries
        self.categoryQuries = categoryQuries
        self.sharedItemsFormatter = sharedItemsFormatter
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.sectionsSubject = .init([])
        self.stateSubject = .init(.regular)
        self.itemsMovedSubject = .init()
        self.isRestoreButtonEnabledSubject = .init(false)
        self.cancellables = []

        self.expectedEventTypes = [
            ItemsAddedEvent.self,
            ItemsRemovedEvent.self,
            ItemUpdatedEvent.self,
            ItemsReorderedEvent.self,
            ItemsMovedToBasketEvent.self,
            ItemsMovedToListEvent.self
        ]

        self.bind()
    }

    public func setList(_ list: ListViewModel) {
        self.list = list
    }

    public func cleanUp() {
        commandBus.remove(.items)
        isRestoreButtonEnabledSubject.send(false)
        stateSubject.send(.regular)
    }

    public func fetchItems() {
        let categories = categoryQuries.fetchCategories()
        let items = itemQueries.fetchItemsToBuyFromList(with: .fromUuid(list.uuid))

        let sections = categories.reduce(into: [ItemsSectionViewModel]()) { result, category in
            let itemsInCategory = items.filter { $0.categoryId == category.id }
            result += !itemsInCategory.isEmpty ? [ItemsSectionViewModel(category, itemsInCategory)] : []
        }

        sectionsSubject.send(sections)
    }

    public func restoreItem() {
        guard commandBus.canUndo(.items) else {
            return
        }

        commandBus.undo(.items)
    }

    public func addItem(with name: String) {
        commandBus.execute(
            AddItemCommand.withDefaultCategory(name, "", .fromUuid(list.uuid))
        )
    }

    public func addToBasketAllItems() {
        let ids: [Id<Item>] = sectionsSubject.value.flatMap { $0.items.map { .fromUuid($0.uuid) } }
        commandBus.execute(MoveItemsToBasketCommand(ids, .fromUuid(list.uuid)))
    }

    public func addToBasketItems(with uuids: [UUID]) {
        commandBus.execute(
            MoveItemsToBasketCommand(uuids.map { .fromUuid($0) }, .fromUuid(list.uuid))
        )
    }

    public func removeAllItems() {
        let items: [Item] = sectionsSubject.value.flatMap { self.items(from: $0) }
        commandBus.execute(RemoveItemsCommand(items))
    }

    public func removeItems(with uuids: [UUID]) {
        let items: [Item] = sectionsSubject.value
            .flatMap { self.items(from: $0) }
            .filter { uuids.contains($0.id.toUuid()) }

        commandBus.execute(RemoveItemsCommand(items))
    }

    public func moveItem(
        fromPosition: (section: Int, index: Int),
        toPosition: (section: Int, index: Int)
    ) {
        var sections = sectionsSubject.value
        let item = sections[fromPosition.section].items[fromPosition.index]

        sections[fromPosition.section] =
            sections[fromPosition.section].withRemovedItem(at: fromPosition.index)

        sections[toPosition.section] =
            sections[toPosition.section].withInsertedItem(item, at: toPosition.index)

        if fromPosition.section == toPosition.section {
            itemsMovedSubject.send((fromPosition.section, toPosition.section))
        }

        setItemsOrder(sections.flatMap { $0.items })
        updateItemsCategory(item, to: sections[toPosition.section].category)
    }

    private func setItemsOrder(_ items: [ItemToBuyViewModel]) {
        let itemIds: [Id<Item>] = items.map { $0.uuid }.map { .fromUuid($0) }
        let listId: Id<List> = .fromUuid(list.uuid)

        commandBus.execute(
            SetItemsOrderCommand(itemIds, listId)
        )
    }

    private func updateItemsCategory(_ item: ItemToBuyViewModel, to category: ItemsCategoryViewModel) {
        guard item.categoryName != category.name else {
            return
        }

        let itemId: Id<Item> = .fromUuid(item.uuid)
        let categoryId: Id<ItemsCategory> = .fromUuid(category.uuid)
        let listId: Id<List> = .fromUuid(list.uuid)

        commandBus.execute(
            UpdateItemCommand(itemId, item.name, item.info, categoryId, listId)
        )
    }

    public func setState(_ state: State) {
        stateSubject.send(state)
    }

    public func formattedItemsWithCategories() -> String {
        sharedItemsFormatter.formatWithCategories(itemsToShare())
    }

    public func formattedItemsWithoutCategories() -> String {
        sharedItemsFormatter.formatWithoutCategories(itemsToShare())
    }

    private func bind() {
        eventBus.events
            .filterType(expectedEventTypes)
            .sink { [weak self] _ in
                self?.fetchItems()
                self?.stateSubject.send(.regular)
            }
            .store(in: &cancellables)

        sectionsPublisher
            .map { [weak self] _ in self?.commandBus.canUndo(.items) == true }
            .subscribe(isRestoreButtonEnabledSubject)
            .store(in: &cancellables)
    }

    private func hasItemsInBasket() -> Bool {
        itemQueries.hasItemsInBasketOfList(with: .fromUuid(list.uuid))
    }

    private func items(from section: ItemsSectionViewModel) -> [Item] {
        section.items.map { item in
            Item(
                id: .fromUuid(item.uuid),
                name: item.name,
                info: item.info,
                state: .toBuy,
                categoryId: .fromUuid(section.category.uuid),
                listId: .fromUuid(list.uuid)
            )
        }
    }

    private func itemsToShare() -> [ItemToShare] {
        sectionsSubject.value
            .flatMap { $0.items }
            .map { .init(name: $0.name, info: $0.info, categoryName: $0.categoryName) }
    }
}

public extension ItemsViewModel {
    enum State {
        case editing
        case regular
    }
}
