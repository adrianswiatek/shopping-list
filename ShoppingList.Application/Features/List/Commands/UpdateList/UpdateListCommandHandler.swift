import ShoppingList_Domain

public final class UpdateListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let eventBus: EventBus

    public init(_ listRepository: ListRepository, _ eventBus: EventBus) {
        self.listRepository = listRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is UpdateListCommand
    }

    public func execute(_ command: Command) {
        guard
            canExecute(command),
            let command = command as? UpdateListCommand,
            let listBeforeUpdate = listRepository.list(with: command.id),
            listBeforeUpdate.name != command.name
        else {
            return
        }

        let listAfterUpdate = listBeforeUpdate.withChangedName(command.name)

        listRepository.update(listAfterUpdate)
        eventBus.send(ListUpdatedEvent(listBeforeUpdate, listAfterUpdate))
    }
}
