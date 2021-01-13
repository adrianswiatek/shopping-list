import ShoppingList_Domain

public final class UpdateListCommandHandler: CommandHandler {
    private let listRepository: ListRepository

    public init(_ listRepository: ListRepository) {
        self.listRepository = listRepository
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

        listRepository.update(list.withChangedName(command.name))
    }
}
