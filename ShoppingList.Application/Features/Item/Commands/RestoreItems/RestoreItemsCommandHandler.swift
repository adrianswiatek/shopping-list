import ShoppingList_Domain

public final class RestoreItemsCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RestoreItemsCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RestoreItemsCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        itemRepository.addItems(command.items)
        eventBus.send(ItemsAddedEvent(command.items))
    }
}
