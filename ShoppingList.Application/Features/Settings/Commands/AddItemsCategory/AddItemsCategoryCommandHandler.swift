import ShoppingList_Domain

public final class AddItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository

    public init(_ categoryRepository: ItemsCategoryRepository) {
        self.categoryRepository = categoryRepository
    }

    public func canExecute(_ command: Command) -> Bool {
        guard let command = command as? AddItemsCategoryCommand else {
            return false
        }

        let categoryWithGivenName = categoryRepository.allCategories().first {
            $0.name == command.name
        }
        return categoryWithGivenName == nil
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? AddItemsCategoryCommand else {
            assertionFailure("Cannot execute given command.")
            return
        }

        categoryRepository.add(.withName(command.name))
    }
}
