public final class UpdateItemsCategoryCommandHandler: CommandHandler {
    private let categoryRepository: ItemsCategoryRepository
    private let localPreferences: LocalPreferences

    public init(
        _ categoryRepository: ItemsCategoryRepository,
        _ localPreferences: LocalPreferences
    ) {
        self.categoryRepository = categoryRepository
        self.localPreferences = localPreferences
    }

    public func canExecute(_ command: Command) -> Bool {
        command is UpdateItemsCategoryCommand
    }

    public func execute(_ command: Command) {
        guard
            canExecute(command),
            let command = command as? UpdateItemsCategoryCommand,
            let category = categoryRepository.category(with: command.id),
            category.name != command.name
        else {
            return
        }

        if category.isDefault {
            localPreferences.setDefaultCategoryName(command.name)
        } else {
            categoryRepository.update(category.withName(command.name))
        }
    }
}
