public final class RemoveListCommandHandler: CommandHandler {
    private let listRepository: ListRepository

    public init(_ listRepository: ListRepository) {
        self.listRepository = listRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        (command as? RemoveListCommand) != nil
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? RemoveListCommand else {
            return
        }

        listRepository.remove(by: command.list.id)
    }
}
