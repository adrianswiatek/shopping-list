public final class SetItemsOrderCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        command is SetItemsOrderCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? SetItemsOrderCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        itemRepository.setItemsOrder(
            with: command.orderedIds,
            inListWithId: command.listId,
            forState: .toBuy
        )
    }
}
