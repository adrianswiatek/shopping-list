import ShoppingList_Domain

import Combine

public final class ItemAddedToListOrUpdatedListener {
    private let commandBus: CommandBus
    private let eventBus: EventBus

    private var cancellables: Set<AnyCancellable>

    public init(commandBus: CommandBus, eventBus: EventBus) {
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.cancellables = []
    }

    public func start() {
        eventBus.events
            .filterType(ItemsAddedEvent.self)
            .map { $0 as! ItemsAddedEvent }
            .sink { [weak self] in
                let command = AddModelItemsCommand($0.items)
                self?.commandBus.execute(command)
            }
            .store(in: &cancellables)

        eventBus.events
            .filterType(ItemUpdatedEvent.self)
            .map { $0 as! ItemUpdatedEvent }
            .sink { [weak self] in
                let command = AddModelItemsCommand([$0.itemAfterUpdate])
                self?.commandBus.execute(command)
            }
            .store(in: &cancellables)
    }
}
