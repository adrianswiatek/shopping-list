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
        command is UpdateItemsCategoryCommand
    }

    public func execute(_ command: Command) {
        guard
            canExecute(command),
            let command = command as? UpdateItemsCategoryCommand,
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
