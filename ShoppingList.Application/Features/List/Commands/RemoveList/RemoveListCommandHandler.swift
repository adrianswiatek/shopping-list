public final class RemoveListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let eventBus: EventBus

    public init(_ listRepository: ListRepository, _ eventBus: EventBus) {
        self.listRepository = listRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        (command as? RemoveListCommand) != nil
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RemoveListCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        listRepository.remove(by: command.list.id)
        eventBus.send(ListRemovedEvent(command.list))
    }
}
