import ShoppingList_Domain

public final class UpdateModelItemCommandHandler: CommandHandler {
    private let modelItemRepository: ModelItemRepository
    private let eventBus: EventBus

    public init(_ itemRepository: ModelItemRepository, _ eventBus: EventBus) {
        self.modelItemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        (command as? UpdateModelItemCommand)?.newName.isEmpty == false
    }

    public func execute(_ command: Command) throws {
        guard
            canExecute(command),
            let command = command as? UpdateModelItemCommand,
            let modelItemBeforeUpdate = modelItemRepository.modelItemWithId(command.modelItemId)
        else {
            preconditionFailure("Cannot execute given command.")
        }

        let givenNameAlreadyExists = modelItemRepository
            .allModelItems()
            .map(\.name.localizedLowercase)
            .contains(command.newName.localizedLowercase)

        guard !givenNameAlreadyExists else {
            throw CommandError.executionError
        }

        let modelItemAfterUpdate = ModelItem(
            id: command.modelItemId,
            name: command.newName
        )

        modelItemRepository.update(modelItemAfterUpdate)
        eventBus.send(ModelItemUpdatedEvent(modelItemBeforeUpdate, modelItemAfterUpdate))
    }
}
