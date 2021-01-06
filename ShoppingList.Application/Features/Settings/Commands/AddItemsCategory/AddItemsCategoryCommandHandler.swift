import ShoppingList_Domain

public final class AddItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository

    public init(_ categoryRepository: ItemsCategoryRepository) {
        self.categoryRepository = categoryRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        guard let command = command as? AddItemsCategoryCommand else {
            return false
        }

        let categoryWithGivenName = categoryRepository.allCategories().first {
            $0.name == command.name
        }
        return categoryWithGivenName == nil
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? AddItemsCategoryCommand else {
            return
        }

        categoryRepository.add(.withName(command.name))
    }
}
