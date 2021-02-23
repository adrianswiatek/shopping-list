import ShoppingList_Domain

public final class AddItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository
    private let eventBus: EventBus

    public init(_ categoryRepository: ItemsCategoryRepository, _ eventBus: EventBus) {
        self.categoryRepository = categoryRepository
        self.eventBus = eventBus
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
            preconditionFailure("Cannot execute given command.")
        }

        let category: ItemsCategory = .withName(command.name)

        categoryRepository.add(category)
        eventBus.send(ItemsCategoryAddedEvent(category))
    }
}
