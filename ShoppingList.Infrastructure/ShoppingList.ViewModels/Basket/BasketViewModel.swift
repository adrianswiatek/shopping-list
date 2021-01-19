import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class BasketViewModel: ViewModel {
    public var itemsPublisher: AnyPublisher<[ItemInBasketViewModel], Never> {
        itemsSubject.map { $0.map { .init($0) } }.eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.basket)
    }

    public var isEmpty: Bool {
        itemsSubject.value.isEmpty
    }

    private let itemQueries: ItemQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    private var list: ListViewModel!
    private let itemsSubject: CurrentValueSubject<[Item], Never>
    private var cancellables: Set<AnyCancellable>

    public init(itemQueries: ItemQueries, commandBus: CommandBus, eventBus: EventBus) {
        self.itemQueries = itemQueries
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.itemsSubject = .init([])
        self.cancellables = []

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
            MoveItemsToListCommand(items.map { $0.id.toUuid() })
        )
    }

    public func moveAllItemsToList() {
        commandBus.execute(
            MoveItemsToListCommand(itemsSubject.value.map { $0.id.toUuid() })
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

    private func bind() {
        eventBus.events
            .filter { $0 is ItemAddedEvent || $0 is ItemRemovedEvent || $0 is ItemUpdatedEvent }
            .sink { [weak self] _ in self?.fetchItems() }
            .store(in: &cancellables)
    }
}
