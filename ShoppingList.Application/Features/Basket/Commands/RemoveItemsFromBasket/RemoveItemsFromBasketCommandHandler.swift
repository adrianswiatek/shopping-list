import ShoppingList_Domain

public final class RemoveItemsFromBasketCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RemoveItemsFromBasketCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RemoveItemsFromBasketCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        let items = itemRepository.items(with: command.ids)

        itemRepository.removeItems(with: items.map { $0.id })
        eventBus.send(ItemsRemovedEvent(items))
    }
}
