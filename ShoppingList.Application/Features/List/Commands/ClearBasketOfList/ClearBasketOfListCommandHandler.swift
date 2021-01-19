import ShoppingList_Domain

public final class ClearBasketOfListCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        command is ClearBasketOfListCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? ClearBasketOfListCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        let items = itemRepository.itemsWithState(.inBasket, inListWithId: command.id)
        itemRepository.removeItems(with: items.map { $0.id })
    }
}
