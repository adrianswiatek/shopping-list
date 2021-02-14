import ShoppingList_Domain

public final class MoveItemsToBasketCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is MoveItemsToBasketCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? MoveItemsToBasketCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        itemRepository.updateStateOfItems(with: command.itemIds, to: .inBasket)
        eventBus.send(ItemsMovedToBasketEvent(command.itemIds, command.listId))
    }
}
