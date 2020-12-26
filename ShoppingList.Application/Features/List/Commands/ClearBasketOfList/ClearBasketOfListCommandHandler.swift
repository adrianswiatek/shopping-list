import ShoppingList_Domain

public final class ClearBasketOfListCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        command is ClearBasketOfListCommand
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? ClearBasketOfListCommand else {
            return
        }

        let items = itemRepository.itemsWith(state: .inBasket, inListWithId: command.id)
        itemRepository.remove(items)
    }
}
