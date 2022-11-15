import ShoppingList_Domain

public final class RemoveModelItemCommandHandler: CommandHandler {
    private let modelItemRepository: ModelItemRepository
    private let eventBus: EventBus

    public init(_ modelItemRepository: ModelItemRepository, _ eventBus: EventBus) {
        self.modelItemRepository = modelItemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RemoveModelItemCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RemoveModelItemCommand else {
            preconditionFailure("Cannot execute given command.")
        }
        modelItemRepository.remove(by: command.modelItem.id)
        eventBus.send(ModelItemRemovedEvent(command.modelItem))
    }
}
