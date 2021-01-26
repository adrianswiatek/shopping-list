import ShoppingList_Domain

public final class RestoreItemsCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RestoreItemsCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RestoreItemsCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        itemRepository.addItems(command.items)
    }
}
