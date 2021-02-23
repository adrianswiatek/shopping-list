import ShoppingList_Domain

public final class ClearListCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is ClearListCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? ClearListCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        let items = self.items(from: command)

        itemRepository.removeItems(with: items.map { $0.id })
        eventBus.send(ItemsRemovedEvent(items))
    }

    private func items(from command: ClearListCommand) -> [Item] {
        if !command.items.isEmpty {
            return command.items
        } else {
            return itemRepository.itemsWithState(.toBuy, inListWithId: command.id)
        }
    }
}
