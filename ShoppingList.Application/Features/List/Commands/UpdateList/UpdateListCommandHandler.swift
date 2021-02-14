import ShoppingList_Domain

public final class UpdateListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let eventBus: EventBus

    public init(_ listRepository: ListRepository, _ eventBus: EventBus) {
        self.listRepository = listRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        (command as? UpdateListCommand) != nil
    }

    public func execute(_ command: Command) {
        guard
            canExecute(command),
            let command = command as? UpdateListCommand,
            let list = listRepository.list(with: command.id),
            list.name != command.name
        else {
            return
        }

        let updatedList = list.withChangedName(command.name)

        listRepository.update(updatedList)
        eventBus.send(ListUpdatedEvent(updatedList))
    }
}
