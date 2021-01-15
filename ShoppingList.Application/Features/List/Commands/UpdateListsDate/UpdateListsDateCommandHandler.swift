import ShoppingList_Domain

public final class UpdateListsDateCommandHandler: CommandHandler {
    private let listRepository: ListRepository

    public init(_ listRepository: ListRepository) {
        self.listRepository = listRepository
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
    }
}
