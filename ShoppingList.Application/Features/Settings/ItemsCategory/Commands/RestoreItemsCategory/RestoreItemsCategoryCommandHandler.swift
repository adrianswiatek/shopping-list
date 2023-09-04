public final class RestoreItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository
    private let itemRepository: ItemRepository
    private let eventBus: EventBus

    public init(
        _ categoryRepository: ItemsCategoryRepository,
        _ itemRepository: ItemRepository,
        _ eventBus: EventBus
    ) {
        self.categoryRepository = categoryRepository
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is RestoreItemsCategoryCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RestoreItemsCategoryCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        categoryRepository.add(command.itemsCategory)
        itemRepository.updateCategoryOfItemsWithIds(command.itemIds, toCategory: command.itemsCategory.id)
        eventBus.send(ItemsCategoryAddedEvent(command.itemsCategory))
    }
}
