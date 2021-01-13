import ShoppingList_Application
import Combine

public final class ItemsViewModel: ViewModel {
    public var list: ListViewModel!

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.items)
    }

    private var cancellables: Set<AnyCancellable>

    private let itemQueries: ItemQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    public init(itemQueries: ItemQueries, commandBus: CommandBus, eventBus: EventBus) {
        self.itemQueries = itemQueries
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.cancellables = []

        self.bind()
    }

    public func setList(_ list: ListViewModel) {
        self.list = list
    }

    public func cleanUp() {
        commandBus.remove(.items)
    }

    public func restoreItem() {
        guard commandBus.canUndo(.items) else {
            return
        }

        commandBus.undo(.items)
    }

    public func addToBasketItem(with id: UUID) {
        let command = AddItemsToBasketCommand([])
        commandBus.execute(command)
    }

    public func hasItemsInBasket() -> Bool {
        itemQueries.hasItemsInBasketOfList(with: .fromUuid(list.uuid))
    }

    private func bind() {
        eventBus.events
            .filter { $0 is ItemAddedEvent || $0 is ItemRemovedEvent || $0 is ItemUpdatedEvent }
            .sink { _ in print("Items list should be updated here.") }
            .store(in: &cancellables)
    }
}
