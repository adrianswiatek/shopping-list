import ShoppingList_Domain

public final class RestoreListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ listRepository: ListRepository, _ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.listRepository = listRepository
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RestoreListCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RestoreListCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        listRepository.add(command.list)
        itemRepository.addItems(command.items)

        eventBus.send(ListAddedEvent(command.list))
    }
}
