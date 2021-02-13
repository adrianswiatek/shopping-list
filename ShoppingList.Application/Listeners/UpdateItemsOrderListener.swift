import ShoppingList_Domain
import Combine

public final class UpdateItemsOrderListener {
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
            .compactMap { [weak self] in self?.itemId(from: $0) }
            .compactMap { [weak self] in self?.listId(from: $0) }
            .sink { [weak self] in self?.updateItemsOrder(inListWithId: $0) }
    }

    private func itemId(from event: Event) -> Id<Item>? {
        switch event {
        case let event as ItemAddedEvent: return event.id
        case let event as ItemRemovedEvent: return event.id
        case let event as ItemUpdatedEvent: return event.id
        default: return nil
        }
    }

    private func listId(from itemId: Id<Item>) -> Id<List>? {
        itemRepository.item(with: itemId)?.listId
    }

    private func updateItemsOrder(inListWithId listId: Id<List>) {
        let items = itemRepository.itemsWithState(.toBuy, inListWithId: listId)
        commandBus.execute(SetItemsOrderCommand(items.map { $0.id }, listId))
    }
}
