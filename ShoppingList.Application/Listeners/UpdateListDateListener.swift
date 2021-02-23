import ShoppingList_Domain
import Combine

public final class UpdateListDateListener {
    private let itemRepository: ItemRepository
    private let commandBus: CommandBus
    private let eventBus: EventBus
    private var cancellable: AnyCancellable?

    public init(itemRepository: ItemRepository, commandBus: CommandBus, eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.commandBus = commandBus
        self.eventBus = eventBus
    }

    public func start() {
        cancellable = eventBus.events
            .compactMap { ($0 as? ItemsReorderedEvent)?.listId }
            .sink { [weak self] in
                self?.commandBus.execute(UpdateListsDateCommand($0))
            }
    }
}
