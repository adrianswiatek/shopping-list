public final class UpdateItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository
    private let localPreferences: LocalPreferences
    private let eventBus: EventBus

    public init(
        _ categoryRepository: ItemsCategoryRepository,
        _ localPreferences: LocalPreferences,
        _ eventBus: EventBus
    ) {
        self.categoryRepository = categoryRepository
        self.localPreferences = localPreferences
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        guard let command = command as? UpdateItemsCategoryCommand else {
            return false
        }

        let categoryWithGivenName = categoryRepository.allCategories().first {
            $0.name == command.name
        }
        return categoryWithGivenName == nil
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? UpdateItemsCategoryCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        guard
            let categoryBeforeUpdate = categoryRepository.category(with: command.id),
            categoryBeforeUpdate.name != command.name
        else {
            return
        }

        let categoryAfterUpdate = categoryBeforeUpdate.withName(command.name)

        if categoryBeforeUpdate.isDefault {
            localPreferences.setDefaultCategoryName(categoryAfterUpdate.name)
        } else {
            categoryRepository.update(categoryAfterUpdate)
        }

        eventBus.send(ItemsCategoryUpdatedEvent(categoryBeforeUpdate, categoryAfterUpdate))
    }
}
