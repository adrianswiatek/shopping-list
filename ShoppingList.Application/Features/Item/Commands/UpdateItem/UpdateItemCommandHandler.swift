import ShoppingList_Domain

public final class UpdateItemCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        (command as? UpdateItemCommand)?.name.isEmpty == false
    }

    public func execute(_ command: Command) {
        guard
            canExecute(command),
            let command = command as? UpdateItemCommand,
            let existingItem = itemRepository.item(with: command.itemId)
        else {
            return
        }

        itemRepository.updateItem(Item(
            id: command.itemId,
            name: command.name,
            info: command.info,
            state: existingItem.state,
            categoryId: command.categoryId,
            listId: command.listId
        ))
    }
}
