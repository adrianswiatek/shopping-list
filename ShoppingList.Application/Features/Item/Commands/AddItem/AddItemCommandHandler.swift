import ShoppingList_Domain

public final class AddItemCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        (command as? AddItemCommand)?.name.isEmpty == false
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? AddItemCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        itemRepository.addItems([.toBuy(
            name: command.name,
            info: command.info,
            listId: command.listId,
            categoryId: command.categoryId
        )])
    }
}
