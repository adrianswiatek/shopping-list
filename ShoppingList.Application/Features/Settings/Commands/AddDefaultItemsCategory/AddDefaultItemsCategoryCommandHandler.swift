import ShoppingList_Domain

public final class AddDefaultItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository

    public init(_ categoryRepository: ItemsCategoryRepository) {
        self.categoryRepository = categoryRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        command is AddDefaultItemsCategoryCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), !alreadyExists() else {
            return
        }

        categoryRepository.add(.default)
    }

    private func alreadyExists() -> Bool {
        categoryRepository.category(with: ItemsCategory.default.id) != nil
    }
}
