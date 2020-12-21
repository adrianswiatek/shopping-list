import ShoppingList_Domain

public final class UpdateListCommandHandler: CommandHandler {
    private let listRepository: ListRepository

    public init(_ listRepository: ListRepository) {
        self.listRepository = listRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        (command as? UpdateListCommand) != nil
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? UpdateListCommand else {
            return
        }

        guard let list = listRepository.getList(by: command.id), list.name != command.name else {
            return
        }

        listRepository.update(list.withChangedName(command.name))
    }
}
