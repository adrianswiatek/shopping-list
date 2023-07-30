import ShoppingList_Domain

public final class SendListToWatchCommandHandler: CommandHandler {
    private let connectivityService: ConnectivityService
    private let listRepository: ListRepository
    private let itemRepository: ItemRepository
    private let categoryRepository: ItemsCategoryRepository
    private let eventBus: EventBus

    public init(
        _ connectivityService: ConnectivityService,
        _ listRepository: ListRepository,
        _ itemRepository: ItemRepository,
        _ categoryRepository: ItemsCategoryRepository,
        _ eventBus: EventBus
    ) {
        self.connectivityService = connectivityService
        self.listRepository = listRepository
        self.itemRepository = itemRepository
        self.categoryRepository = categoryRepository
        self.eventBus = eventBus
    }

    public func canExecute(_ command: Command) -> Bool {
        command is SendListToWatchCommand
    }

    public func execute(_ command: Command) {
        guard canExecute(command), let command = command as? SendListToWatchCommand else {
            preconditionFailure("Cannot execute given command.")
        }

        guard let list = listRepository.list(with: command.listId) else {
            assertionFailure("Cannot find list with givenId")
            return
        }

        let items = itemRepository.itemsInList(with: command.listId)
        let categories = categoryRepository.allCategories()

        connectivityService.sendRequest(.make(list)(items)(categories))
    }
}
