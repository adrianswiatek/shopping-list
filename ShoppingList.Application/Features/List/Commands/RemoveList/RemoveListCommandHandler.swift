public final class RemoveListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let eventBus: EventBus

    public init(_ listRepository: ListRepository, _ eventBus: EventBus) {
        self.listRepository = listRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RemoveListCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RemoveListCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        listRepository.remove(by: command.list.id)
        eventBus.send(ListRemovedEvent(command.list))
    }
}
