import ShoppingList_Domain
import ShoppingList_Application
import Combine

public final class ItemsViewModel: ViewModel {
    public private(set) var list: ListViewModel!

    public var itemsPublisher: AnyPublisher<[ItemToBuyViewModel], Never> {
        itemsSubject.map { $0.map { $0.viewModel } }.eraseToAnyPublisher()
    }

    public var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabledPublisher: AnyPublisher<Bool, Never> {
        isRestoreButtonEnabledSubject.eraseToAnyPublisher()
    }

    public var hasItemsInTheBasketPublisher: AnyPublisher<Bool, Never> {
        itemsSubject
            .map { [weak self] _ in self?.hasItemsInBasket() == true }
            .eraseToAnyPublisher()
    }

    public var canShareItems: Bool {
        !itemsSubject.value.isEmpty
    }

    private let itemsSubject: CurrentValueSubject<[(item: Item, viewModel: ItemToBuyViewModel)], Never>
    private let stateSubject: CurrentValueSubject<State, Never>
    private let isRestoreButtonEnabledSubject: CurrentValueSubject<Bool, Never>
    private var cancellables: Set<AnyCancellable>

    private let itemQueries: ItemQueries
    private let categoryQuries: ItemsCategoryQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    public init(
        itemQueries: ItemQueries,
        categoryQuries: ItemsCategoryQueries,
        commandBus: CommandBus,
        eventBus: EventBus
    ) {
        self.itemQueries = itemQueries
        self.categoryQuries = categoryQuries
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.itemsSubject = .init([])
        self.stateSubject = .init(.regular)
        self.isRestoreButtonEnabledSubject = .init(false)
        self.cancellables = []

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

        let result: [(Item, ItemToBuyViewModel)] = itemQueries
            .fetchItemsToBuyFromList(with: .fromUuid(list.uuid))
            .compactMap { item in
                categories
                    .first { category in category.id == item.categoryId }
                    .map { category in ItemToBuyViewModel(item, category) }
                    .map { viewModel in (item, viewModel) }
            }

        itemsSubject.send(result)
    }

    public func restoreItem() {
        guard commandBus.canUndo(.items) else {
            return
        }

        commandBus.undo(.items)
    }

    public func addItem(with name: String) {
        commandBus.execute(
            AddItemCommand.withDefaultCategory(name, "", list.uuid)
        )
    }

    public func addToBasketAllItems() {
        commandBus.execute(
            MoveItemsToBasketCommand(itemsSubject.value.map { $0.viewModel.uuid })
        )
    }

    public func addToBasketItems(with uuids: [UUID]) {
        commandBus.execute(
            MoveItemsToBasketCommand(uuids)
        )
    }

    public func removeAllItems() {
        commandBus.execute(
            RemoveItemsCommand(itemsSubject.value.map { $0.item })
        )
    }

    public func removeItems(with uuids: [UUID]) {
        let items = itemsSubject.value
            .filter { uuids.contains($0.item.id.toUuid()) }
            .map { $0.item }

        commandBus.execute(
            RemoveItemsCommand(items)
        )
    }

    public func setState(_ state: State) {
        stateSubject.send(state)
    }

    private func bind() {
        eventBus.events
            .filter { $0 is ItemAddedEvent || $0 is ItemRemovedEvent || $0 is ItemUpdatedEvent }
            .sink { [weak self] _ in
                self?.fetchItems()
                self?.stateSubject.send(.regular)
            }
            .store(in: &cancellables)

        itemsPublisher
            .map { [weak self] _ in self?.commandBus.canUndo(.items) == true }
            .subscribe(isRestoreButtonEnabledSubject)
            .store(in: &cancellables)
    }

    private func hasItemsInBasket() -> Bool {
        itemQueries.hasItemsInBasketOfList(with: .fromUuid(list.uuid))
    }
}

public extension ItemsViewModel {
    enum State {
        case editing
        case regular
    }
}
