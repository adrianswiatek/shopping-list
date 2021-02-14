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
        let itemUpdateSubscription = eventBus.events
            .map { ($0 as? ItemUpdatedEvent).map { [$0.itemBeforeUpdate.listId, $0.itemAfterUpdate.listId] } ?? [] }

        let itemsAddedSubscription = eventBus.events
            .map { ($0 as? ItemsAddedEvent)?.items.map { $0.listId } ?? [] }

        let itemsRemovedSubscription = eventBus.events
            .map { ($0 as? ItemsRemovedEvent)?.items.map { $0.listId } ?? [] }

        let itemsMovedSubscription = eventBus.events
            .compactMap { ($0 as? ItemsMovedToBasketEvent)?.listId ?? ($0 as? ItemsMovedToListEvent)?.listId }
            .map { [$0] }

        cancellable = Publishers
            .Merge4(
                itemUpdateSubscription,
                itemsAddedSubscription,
                itemsRemovedSubscription,
                itemsMovedSubscription
            )
            .sink { [weak self] in self?.setItemsOrderInLists(with: $0) }
    }

    private func setItemsOrderInLists(with ids: [Id<List>]) {
        for listId in Set(ids) {
            let items = itemRepository.itemsWithState(.toBuy, inListWithId: listId)
            commandBus.execute(SetItemsOrderCommand(items.map { $0.id }, listId))
        }
    }
}
