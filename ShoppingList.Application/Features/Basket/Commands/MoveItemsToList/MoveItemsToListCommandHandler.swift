import ShoppingList_Domain

public final class MoveItemsToListCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        command is MoveItemsToListCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? MoveItemsToListCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        itemRepository.updateStateOfItems(with: command.ids, to: .toBuy)
    }
}
