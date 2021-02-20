import ShoppingList_Domain

public final class RemoveListCommandRefiner: CommandRefiner {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canRefine(_ command: Command) -> Bool {
        command is RemoveListCommand
    }

    public func refine(_ command: Command) -> Command {
        guard canRefine(command), let command = command as? RemoveListCommand else {
            preconditionFailure("Cannot refine given command.")
        }

        let itemsToBuy = itemRepository.itemsWithState(.toBuy, inListWithId: command.list.id)
        let itemsInBasket = itemRepository.itemsWithState(.inBasket, inListWithId: command.list.id)
        return command.withItems(itemsToBuy + itemsInBasket)
    }
}
