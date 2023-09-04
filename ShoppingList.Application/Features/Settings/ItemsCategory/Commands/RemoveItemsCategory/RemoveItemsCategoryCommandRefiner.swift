import ShoppingList_Domain

public final class RemoveItemsCategoryCommandRefiner: CommandRefiner {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canRefine(_ command: Command) -> Bool {
        command is RemoveItemsCategoryCommand
    }

    public func refine(_ command: Command) -> Command {
        guard canRefine(command), let command = command as? RemoveItemsCategoryCommand else {
            preconditionFailure("Cannot refine given command.")
        }

        let items = itemRepository.itemsInCategory(with: command.itemsCategory.id)
        return command.withItemIds(items.map(\.id))
    }
}
