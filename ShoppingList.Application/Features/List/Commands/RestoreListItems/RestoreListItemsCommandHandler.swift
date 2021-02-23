public final class RestoreListItemsCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RestoreListItemsCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RestoreListItemsCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        itemRepository.addItems(command.items)
        eventBus.send(ItemsAddedEvent(command.items))
    }
}
