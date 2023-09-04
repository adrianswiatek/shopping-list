import ShoppingList_Domain

public final class AddModelItemsCommandHandler: CommandHandler {
    private let modelItemRepository: ModelItemRepository
    private let eventBus: EventBus

    public init(_ modelItemRepository: ModelItemRepository, _ eventBus: EventBus) {
        self.modelItemRepository = modelItemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is AddModelItemsCommand
    }

    public func execute(_ command: Command) throws {
        guard canExecute(command), let command = command as? AddModelItemsCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        let modelItems = modelItemRepository.allModelItems()

        let hasDifferentName: (ModelItem) -> Bool = {
            !modelItems.map(\.name.localizedLowercase).contains($0.name.localizedLowercase)
        }

        let modelItemsToAdd = command.modelItems.filter(hasDifferentName)

        guard !modelItemsToAdd.isEmpty else {
            throw CommandError.executionError
        }

        modelItemRepository.add(modelItemsToAdd)
        eventBus.send(ModelItemsAddedEvent(modelItemsToAdd))
    }
}
