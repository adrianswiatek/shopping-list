import ShoppingList_Domain

public final class UpdateModelItemCommandHandler: CommandHandler {
    private let modelItemRepository: ModelItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ModelItemRepository, _ eventBus: EventBus) {
        self.modelItemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        (command as? UpdateModelItemCommand)?.name.isEmpty == false
    }

    public func execute(_ command: Command) {
        guard
            canExecute(command),
            let command = command as? UpdateModelItemCommand,
            let modelItemBeforeUpdate = modelItemRepository.modelItemWithId(command.modelItemId)
        else {
            return
        }

        let modelItemAfterUpdate = ModelItem(
            id: command.modelItemId,
            name: command.name
        )

        modelItemRepository.update(modelItemAfterUpdate)
        eventBus.send(ModelItemUpdatedEvent(modelItemBeforeUpdate, modelItemAfterUpdate))
    }
}
