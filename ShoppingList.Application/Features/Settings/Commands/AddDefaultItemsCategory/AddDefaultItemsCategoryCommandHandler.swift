import ShoppingList_Domain

public final class AddDefaultItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository
    private let eventBus: EventBus

    public init(_ categoryRepository: ItemsCategoryRepository, _ eventBus: EventBus) {
        self.categoryRepository = categoryRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is AddDefaultItemsCategoryCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), !alreadyExists() else {
            return
        }

        categoryRepository.add(.default)
        eventBus.send(ItemsCategoryAddedEvent(.default))
    }

    private func alreadyExists() -> Bool {
        categoryRepository.category(with: ItemsCategory.default.id) != nil
    }
}
