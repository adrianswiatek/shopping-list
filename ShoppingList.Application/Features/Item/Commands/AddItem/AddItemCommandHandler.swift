import ShoppingList_Domain

public final class AddItemCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        (command as? AddItemCommand)?.name.isEmpty == false
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? AddItemCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        let item: Item = .toBuy(
            name: command.name,
            info: command.info,
            listId: command.listId,
            categoryId: command.categoryId
        )

        itemRepository.addItems([item])
        eventBus.send(ItemsAddedEvent([item]))
    }
}
