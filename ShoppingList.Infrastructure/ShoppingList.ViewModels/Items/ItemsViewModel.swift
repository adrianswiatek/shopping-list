import ShoppingList_Application

public final class ItemsViewModel: ViewModel {
    public var title: String {
        list.name
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.items)
    }

    private var list: ListViewModel!
    private var itemQueries: ItemQueries
    private let commandBus: CommandBus

    public init(itemQueries: ItemQueries, commandBus: CommandBus) {
        self.commandBus = commandBus
        self.itemQueries = itemQueries
    }

    public func setList(_ list: ListViewModel) {
        self.list = list
    }

    public func cleanUp() {
        commandBus.remove(.items)
    }

    public func restoreItem() {
        guard commandBus.canUndo(.items) else {
            return
        }

        commandBus.undo(.items)
        // fetchItems()
    }

    public func addToBasketItem(with id: UUID) {
        let command = AddItemsToBasketCommand([])
        commandBus.execute(command)
    }

    public func hasItemsInBasket() -> Bool {
        itemQueries.hasItemsInBasketOfList(with: .fromUuid(list.uuid))
    }
}
