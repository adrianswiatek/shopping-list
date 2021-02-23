public final class RemoveItemsCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RemoveItemsCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RemoveItemsCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        let items = itemRepository.items(with: command.items.map { $0.id })

        itemRepository.removeItems(with: items.map { $0.id })
        eventBus.send(ItemsRemovedEvent(items))
    }
}
