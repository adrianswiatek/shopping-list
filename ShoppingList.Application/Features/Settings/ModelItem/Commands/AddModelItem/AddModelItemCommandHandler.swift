import ShoppingList_Domain

public final class AddModelItemCommandHandler: CommandHandler {
    private let modelItemRepository: ModelItemRepository
    private let eventBus: EventBus

    public init(_ modelItemRepository: ModelItemRepository, _ eventBus: EventBus) {
        self.modelItemRepository = modelItemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is AddModelItemCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? AddModelItemCommand else {
            preconditionFailure("Cannot execute given command.")
        }
        modelItemRepository.add(command.modelItem)
        eventBus.send(ModelItemAddedEvent(command.modelItem))
    }
}
