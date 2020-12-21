import ShoppingList_Domain

public final class ClearListCommandHandler: CommandHandler {
    private let listRepository: ListRepository
    private let itemRepository: ItemRepository

    public init(_ listRepository: ListRepository, _ itemRepository: ItemRepository) {
        self.listRepository = listRepository
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        command is ClearListCommand
    }

    public func execute(_ command: CommandNew) {
        guard
            canExecute(command),
            let command = command as? ClearListCommand,
            let list = listRepository.getList(by: command.id)
        else {
            return
        }

        let items = itemRepository.getItemsWith(state: .toBuy, in: list)
        itemRepository.remove(items)
    }
}
