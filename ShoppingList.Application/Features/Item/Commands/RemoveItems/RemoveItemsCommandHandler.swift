public final class RemoveItemsCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RemoveItemsCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RemoveItemsCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        itemRepository.removeItems(with: command.ids)
    }
}
