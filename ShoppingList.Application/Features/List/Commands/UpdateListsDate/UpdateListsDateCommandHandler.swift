import ShoppingList_Domain

public final class UpdateListsDateCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let eventBus: EventBus

    public init(_ listRepository: ListRepository, _ eventBus: EventBus) {
        self.listRepository = listRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is UpdateListsDateCommand
    }

    public func execute(_ command: Command) {
        guard
            canExecute(command),
            let command = command as? UpdateListsDateCommand,
            let list = listRepository.list(with: command.id)
        else {
            return
        }

        listRepository.update(list.withChangedDate())
        eventBus.send(ListUpdatedEvent(list))
    }
}
