import ShoppingList_Domain

public final class ClearBasketOfListCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is ClearBasketOfListCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? ClearBasketOfListCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        let items = itemRepository.itemsWithState(.inBasket, inListWithId: command.id)

        itemRepository.removeItems(with: items.map { $0.id })
        eventBus.send(ItemsRemovedEvent(items))
    }
}
