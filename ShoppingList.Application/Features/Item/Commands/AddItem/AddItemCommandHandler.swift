import ShoppingList_Domain

public final class AddItemCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        (command as? AddItemCommand)?.name.isEmpty == false
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? AddItemCommand else {
            return
        }

        itemRepository.add(.toBuy(
            name: command.name,
            info: command.info,
            listId: command.listId,
            categoryId: command.categoryId
        ))
    }
}
