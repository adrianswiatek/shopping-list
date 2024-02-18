import ShoppingList_Domain

public final class UpdateItemCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ItemRepository, _ eventBus: EventBus) {
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        (command as? UpdateItemCommand)?.name.isEmpty == false
    }

    public func execute(_ command: Command) {
        guard
            canExecute(command),
            let command = command as? UpdateItemCommand,
            let itemBeforeUpdate = itemRepository.item(with: command.itemId)
        else {
            return
        }

        let itemAfterUpdate = Item(
            id: command.itemId,
            name: command.name,
            info: command.info,
            state: itemBeforeUpdate.state,
            categoryId: command.categoryId,
            listId: command.listId,
            externalUrl: command.externalUrl.flatMap(URL.init)
        )

        itemRepository.updateItem(itemAfterUpdate)
        eventBus.send(ItemUpdatedEvent(itemBeforeUpdate, itemAfterUpdate))
    }
}
