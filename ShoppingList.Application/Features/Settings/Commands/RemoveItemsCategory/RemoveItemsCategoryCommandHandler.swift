import ShoppingList_Domain

public final class RemoveItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository
    private let itemRepository: ItemRepository

    public init(
        _ categoryRepository: ItemsCategoryRepository,
        _ itemRepository: ItemRepository
    ) {
        self.categoryRepository = categoryRepository
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        guard let command = command as? RemoveItemsCategoryCommand else {
            return false
        }
        return !command.itemsCategory.isDefault
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? RemoveItemsCategoryCommand else {
            return
        }

        let items = itemRepository.items(in: command.itemsCategory)
        itemRepository.updateCategory(of: items, to: .default)

        categoryRepository.remove(by: command.itemsCategory.id)
    }
}
