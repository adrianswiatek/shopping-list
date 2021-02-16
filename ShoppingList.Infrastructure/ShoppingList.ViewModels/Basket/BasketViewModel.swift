import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class BasketViewModel: ViewModel {
    public var itemsPublisher: AnyPublisher<[ItemInBasketViewModel], Never> {
        itemsSubject.map { $0.map { .init($0) } }.eraseToAnyPublisher()
    }

    public var statePublisher: AnyPublisher<State, Never> {
        stateSubject.removeDuplicates().eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabledPublisher: AnyPublisher<Bool, Never> {
        itemsPublisher
            .compactMap { [weak self] _ in self?.commandBus.canUndo(.basket) }
            .eraseToAnyPublisher()

    }

    public var isEmpty: Bool {
        itemsSubject.value.isEmpty
    }

    private let itemQueries: ItemQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    private var list: ListViewModel!
    private let expectedEventTypes: [Event.Type]

    private let itemsSubject: CurrentValueSubject<[Item], Never>
    private let stateSubject: CurrentValueSubject<State, Never>
    private var cancellables: Set<AnyCancellable>

    public init(itemQueries: ItemQueries, commandBus: CommandBus, eventBus: EventBus) {
        self.itemQueries = itemQueries
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.itemsSubject = .init([])
        self.stateSubject = .init(.regular)
        self.cancellables = []

        self.expectedEventTypes = [
            ItemsAddedEvent.self,
            ItemsRemovedEvent.self,
            ItemUpdatedEvent.self,
            ItemsMovedToListEvent.self,
            ItemsMovedToBasketEvent.self
        ]

        self.bind()
    }

    public func setList(_ list: ListViewModel) {
        self.list = list
    }

    public func fetchItems() {
        let items = itemQueries
            .fetchItemsInBasketFromList(with: .fromUuid(list.uuid))
            .sorted { $0.name < $1.name }

        itemsSubject.send(items)
    }

    public func cleanUp() {
        commandBus.remove(.basket)
    }

    public func moveToListItems(with uuids: [UUID]) {
        let items = itemsSubject.value.filter { uuids.contains($0.id.toUuid()) }

        commandBus.execute(
            MoveItemsToListCommand(items.map { $0.id }, .fromUuid(list.uuid))
        )
    }

    public func moveAllItemsToList() {
        commandBus.execute(
            MoveItemsToListCommand(itemsSubject.value.map { $0.id }, .fromUuid(list.uuid))
        )
    }

    public func restoreItem() {
        guard commandBus.canUndo(.basket) else {
            return
        }

        commandBus.undo(.basket)
    }

    public func removeItems(with uuids: [UUID]) {
        let items = itemsSubject.value.filter { uuids.contains($0.id.toUuid()) }

        commandBus.execute(
            RemoveItemsFromBasketCommand(items)
        )
    }

    public func removeAllItems() {
        commandBus.execute(
            RemoveItemsFromBasketCommand(itemsSubject.value)
        )
    }

    public func setState(_ state: State) {
        stateSubject.send(state)
    }

    private func bind() {
        eventBus.events
            .filterType(expectedEventTypes)
            .sink { [weak self] _ in
                self?.fetchItems()
                self?.stateSubject.send(.regular)
            }
            .store(in: &cancellables)
    }
}

public extension BasketViewModel {
    enum State {
        case editing
        case regular
    }
}
