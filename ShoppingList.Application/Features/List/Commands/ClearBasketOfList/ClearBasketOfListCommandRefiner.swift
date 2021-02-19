import ShoppingList_Domain

public final class ClearBasketOfListCommandRefiner: CommandRefiner {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canRefine(_ command: Command) -> Bool {
        command is ClearBasketOfListCommand
    }

    public func refine(_ command: Command) -> Command {
        guard canRefine(command), let command = command as? ClearBasketOfListCommand else {
            preconditionFailure("Cannot refine given command.")
        }

        let items = itemRepository.itemsWithState(.inBasket, inListWithId: command.id)
        return command.withItems(items)
    }
}
