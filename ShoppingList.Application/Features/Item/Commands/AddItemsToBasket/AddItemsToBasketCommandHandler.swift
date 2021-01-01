import ShoppingList_Domain

public final class AddItemsToBasketCommandHandler: CommandHandler {
    private let itemRepository: ItemRepository

    public init(_ itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }

    public func canExecute(_ command: CommandNew) -> Bool {
        command is AddItemsToBasketCommand
    }

    public func execute(_ command: CommandNew) {
        guard canExecute(command), let command = command as? AddItemsToBasketCommand else {
            return
        }

        itemRepository.updateStateOfItems(with: command.ids, to: .toBuy)
    }    
}

//
//public final class AddItemsToBasketCommand: ItemsCommand {
//    public override func execute(at indexPaths: [IndexPath]) {
//        viewController.tableView.deleteRows(at: indexPaths, with: .right)
//        repository.updateState(of: items, to: .inBasket)
//    }
//
//    public override func undo(with items: [Item]) {
//        repository.updateState(of: items, to: .toBuy)
//    }
//}
