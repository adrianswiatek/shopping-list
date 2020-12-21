public final class RemoveItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository

    public init(_ categoryRepository: ItemsCategoryRepository) {
        self.categoryRepository = categoryRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        command is RemoveItemsCategoryCommand
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? RemoveItemsCategoryCommand else {
            return
        }

        categoryRepository.remove(by: command.itemsCategory.id)
    }
}
