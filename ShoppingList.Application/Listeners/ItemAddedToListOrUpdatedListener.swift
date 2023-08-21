import ShoppingList_Domain

import Combine

public final class ItemAddedToListOrUpdatedListener {
    private let modelItemCommands: ModelItemCommands
    private let modelItemRepository: ModelItemRepository
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    private var cancellables: Set<AnyCancellable>

    public init(
        modelItemCommands: ModelItemCommands,
        modelItemRepository: ModelItemRepository,
        itemRepository: ItemRepository,
        eventBus: EventBus
    ) {
        self.modelItemCommands = modelItemCommands
        self.modelItemRepository = modelItemRepository
        self.itemRepository = itemRepository
        self.eventBus = eventBus

        self.cancellables = []
    }

    public func start() {
        eventBus.events
            .filterType(ItemsAddedEvent.self)
            .map { $0 as! ItemsAddedEvent }
            .sink { [weak self] in
                self?.modelItemCommands.addFromItems($0.items)
            }
            .store(in: &cancellables)

        eventBus.events
            .filterType(ItemUpdatedEvent.self)
            .map { $0 as! ItemUpdatedEvent }
            .sink { [weak self] in
                self?.modelItemCommands.addFromItems([$0.itemAfterUpdate])
            }
            .store(in: &cancellables)
    }
}
