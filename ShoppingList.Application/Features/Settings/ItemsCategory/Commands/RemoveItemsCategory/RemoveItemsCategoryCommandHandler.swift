import ShoppingList_Domain

public final class RemoveItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository
    private let itemRepository: ItemRepository
    private let modelItemRepository: ModelItemRepository
    private let eventBus: EventBus

    public init(
        _ categoryRepository: ItemsCategoryRepository,
        _ itemRepository: ItemRepository,
        _ modelItemRepository: ModelItemRepository,
        _ eventBus: EventBus
    ) {
        self.categoryRepository = categoryRepository
        self.itemRepository = itemRepository
        self.modelItemRepository = modelItemRepository
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

        let category: ItemsCategory = command.itemsCategory
        let defaultCategory: ItemsCategory = ItemsCategory.default

        itemRepository.updateCategoryOfItemsWithIds(
            itemRepository.itemsInCategory(with: category.id).map(\.id),
            toCategory: defaultCategory.id
        )

        categoryRepository.remove(by: category.id)
        eventBus.send(ItemsCategoryRemovedEvent(category))
    }
}
