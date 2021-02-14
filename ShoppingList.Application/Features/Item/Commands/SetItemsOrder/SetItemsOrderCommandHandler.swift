public final class SetItemsOrderCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
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

        eventBus.send(ItemsReorderedEvent(command.listId))
    }
}
