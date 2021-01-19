public final class RemoveListCommandHandler: CommandHandler {
    private let listRepository: ListRepository

    public init(_ listRepository: ListRepository) {
        self.listRepository = listRepository
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
    }
}
