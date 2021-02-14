import ShoppingList_Domain

public final class MoveItemsToListCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is MoveItemsToListCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? MoveItemsToListCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        itemRepository.updateStateOfItems(with: command.itemIds, to: .toBuy)
        eventBus.send(ItemsMovedToListEvent(command.itemIds, command.listId))
    }
}
