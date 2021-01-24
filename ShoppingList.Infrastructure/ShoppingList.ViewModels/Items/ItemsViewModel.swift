import ShoppingList_Domain
import ShoppingList_Application
import Combine

public final class ItemsViewModel: ViewModel {
    public private(set) var list: ListViewModel!

    public var itemsPublisher: AnyPublisher<[ItemToBuyViewModel], Never> {
        itemsSubject.eraseToAnyPublisher()
    }

    public var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.items)
    }

    private let itemsSubject: CurrentValueSubject<[ItemToBuyViewModel], Never>
    private let stateSubject: CurrentValueSubject<State, Never>
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
        self.cancellables = []

        self.bind()
    }

    public func setList(_ list: ListViewModel) {
        self.list = list
    }

    public func cleanUp() {
        commandBus.remove(.items)
    }

    public func fetchItems() {
        let categories = categoryQuries.fetchCategories()
        let items = itemQueries.fetchItemsToBuyFromList(with: .fromUuid(list.uuid))

        let itemViewModels = items.compactMap { item in
            categories
                .first { category in category.id == item.categoryId }
                .map { category in ItemToBuyViewModel(item, category) }
        }

        itemsSubject.send(itemViewModels)
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

    public func moveToBasketItem(with uuid: UUID) {
        let command = MoveItemsToBasketCommand([])
        commandBus.execute(command)
    }

    public func hasItemsInBasket() -> Bool {
        itemQueries.hasItemsInBasketOfList(with: .fromUuid(list.uuid))
    }

    public func setState(_ state: State) {
        stateSubject.send(state)
    }

    private func bind() {
        eventBus.events
            .filter { $0 is ItemAddedEvent || $0 is ItemRemovedEvent || $0 is ItemUpdatedEvent }
            .sink { [weak self] _ in self?.fetchItems() }
            .store(in: &cancellables)
    }
}

public extension ItemsViewModel {
    enum State {
        case editing
        case regular
    }
}
