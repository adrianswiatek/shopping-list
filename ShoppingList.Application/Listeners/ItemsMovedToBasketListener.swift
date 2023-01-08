import ShoppingList_Domain
import Combine

public final class ItemsMovedToBasketListener {
    private let modelItemRepository: ModelItemRepository
    private let itemRepository: ItemRepository
    private let eventBus: EventBus
    private var cancellable: AnyCancellable?

    public init(
        modelItemRepository: ModelItemRepository,
        itemRepository: ItemRepository,
        eventBus: EventBus
    ) {
        self.modelItemRepository = modelItemRepository
        self.itemRepository = itemRepository
        self.eventBus = eventBus
    }

    public func start() {
        cancellable = eventBus.events
            .filterType(ItemsMovedToBasketEvent.self)
            .map { $0 as! ItemsMovedToBasketEvent }
            .sink { [weak self] in
                self?.updateModelItemsBasedOdItemsWithIds($0.itemIds)
            }
    }

    private func updateModelItemsBasedOdItemsWithIds(_ ids: [Id<Item>]) {
        let items = itemRepository.items(with: ids)
        let modelItems = modelItemRepository.modelItemsWithNames(items.map(\.name))

        let hasDifferentName: (Item) -> Bool = {
            !modelItems.map(\.name).contains($0.name)
        }

        let hasDifferentCategory: (Item) -> Bool = {
            !modelItems.map(\.categoryId).contains($0.categoryId)
        }

        let canAdd: (Item) -> Bool = {
            hasDifferentName($0) || hasDifferentCategory($0)
        }

        let modelItemsToAdd = items
            .filter(canAdd)
            .map(ModelItem.newFromItem)

        modelItemRepository.add(modelItemsToAdd)
    }
}
