public final class AddListCommandHandler: CommandHandler {
    private let listRepository: ListRepository

    public init(_ listRepository: ListRepository) {
        self.listRepository = listRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        (command as? AddListCommand) != nil
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? AddListCommand else {
            return
        }

        listRepository.add(command.list)
    }
}
