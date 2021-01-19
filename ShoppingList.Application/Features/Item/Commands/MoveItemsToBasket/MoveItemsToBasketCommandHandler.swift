import ShoppingList_Domain

public final class MoveItemsToBasketCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        command is MoveItemsToBasketCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? MoveItemsToBasketCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        itemRepository.updateStateOfItems(with: command.ids, to: .inBasket)
    }    
}
