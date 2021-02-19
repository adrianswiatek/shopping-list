import ShoppingList_Domain

public final class ClearListCommandRefiner: CommandRefiner {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canRefine(_ command: Command) -> Bool {
        command is ClearListCommand
    }

    public func refine(_ command: Command) -> Command {
        guard canRefine(command), let command = command as? ClearListCommand else {
            preconditionFailure("Cannot refine given command.")
        }

        let items = itemRepository.itemsWithState(.toBuy, inListWithId: command.id)
        return command.withItems(items)
    }
}
