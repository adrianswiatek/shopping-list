public final class ReclaimItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository
    private let itemRepository: ItemRepository

    public init(_ categoryRepository: ItemsCategoryRepository, _ itemRepository: ItemRepository) {
        self.categoryRepository = categoryRepository
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        command is ReclaimItemsCategoryCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? ReclaimItemsCategoryCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        categoryRepository.add(command.itemsCategory)

        let items = itemRepository.items(with: command.itemIds)
        itemRepository.updateCategory(of: items, to: command.itemsCategory)
    }
}
