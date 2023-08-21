import ShoppingList_Domain

public final class ModelItemService: ModelItemCommands, ModelItemQueries {
    private let modelItemRepository: ModelItemRepository
    private let itemRepository: ItemRepository

    public init(
        _ modelItemRepository: ModelItemRepository,
        _ itemRepository: ItemRepository
    ) {
        self.modelItemRepository = modelItemRepository
        self.itemRepository = itemRepository
    }

    public func fetchModelItems() -> [ModelItem] {
        modelItemRepository.allModelItems()
    }

    public func addFromItems(_ items: [Item]) {
        let modelItems = modelItemRepository.allModelItems()

        let hasDifferentName: (Item) -> Bool = {
            !modelItems.map(\.name).contains($0.name)
        }

        let modelItemsToAdd = items
            .filter(hasDifferentName)
            .map(ModelItem.newFromItem)

        modelItemRepository.add(modelItemsToAdd)
    }

    public func addFromExistingItems() {
        addFromItems(itemRepository.allItems())
    }
}
