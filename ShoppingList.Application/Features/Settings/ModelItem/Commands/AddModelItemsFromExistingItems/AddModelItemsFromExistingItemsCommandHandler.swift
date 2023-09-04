import ShoppingList_Domain

public final class AddModelItemsFromExistingItemsCommandHandler: CommandHandler {
    private let modelItemRepository: ModelItemRepository
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(
        _ modelItemRepository: ModelItemRepository,
        _ itemRepository: ItemRepository,
        _ eventBus: EventBus
    ) {
        self.modelItemRepository = modelItemRepository
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is AddModelItemsFromExistingItemsCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command) else {
            preconditionFailure("Cannot execute given command.")
        }

        let items = itemRepository.allItems()
        let modelItems = modelItemRepository.allModelItems()

        let hasDifferentName: (Item) -> Bool = {
            !modelItems.map(\.name.localizedLowercase).contains($0.name.localizedLowercase)
        }

        let modelItemsToAdd = items
            .filter(hasDifferentName)
            .map(ModelItem.newFromItem)

        guard !modelItemsToAdd.isEmpty else {
            return
        }

        modelItemRepository.add(modelItemsToAdd)
        eventBus.send(ModelItemsAddedEvent(modelItemsToAdd))
    }
}
