import ShoppingList_Domain

public final class RemoveItemsCategoryCommandHandler: CommandHandler {
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
        guard let command = command as? RemoveItemsCategoryCommand else {
            return false
        }
        return !command.itemsCategory.isDefault
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RemoveItemsCategoryCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        let items = itemRepository.itemsInCategory(with: command.itemsCategory.id)
        itemRepository.updateCategory(ofItems: items.map { $0.id }, toCategory: ItemsCategory.default.id)

        categoryRepository.remove(by: command.itemsCategory.id)
        eventBus.send(ItemsCategoryRemovedEvent(command.itemsCategory))
    }
}
