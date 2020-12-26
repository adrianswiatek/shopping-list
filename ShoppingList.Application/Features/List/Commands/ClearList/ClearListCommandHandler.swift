import ShoppingList_Domain

public final class ClearListCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        command is ClearListCommand
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? ClearListCommand else {
            return
        }

        let items = itemRepository.itemsWith(state: .toBuy, inListWithId: command.id)
        itemRepository.remove(items)
    }
}
