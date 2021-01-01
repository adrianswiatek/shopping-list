import ShoppingList_Application

public final class ItemsViewModel: ViewModel {
    public var title: String {
        list.name
    }

    private var list: ListViewModel!
    private let commandBus: CommandBus

    public init(commandBus: CommandBus) {
        self.commandBus = commandBus
    }

    public func setList(_ list: ListViewModel) {
        self.list = list
    }

    public func cleanUp() {
        commandBus.remove(.items)
    }

    public func addToBasketItem(with id: UUID) {
        let command = AddItemsToBasketCommand([])
        commandBus.execute(command)
    }
}
