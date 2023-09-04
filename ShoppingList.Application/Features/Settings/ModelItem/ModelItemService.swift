import ShoppingList_Domain

public final class ModelItemService: ModelItemQueries {
    private let modelItemRepository: ModelItemRepository

    public init(_ modelItemRepository: ModelItemRepository) {
        self.modelItemRepository = modelItemRepository
    }

    public func fetchModelItems() -> [ModelItem] {
        modelItemRepository.allModelItems()
    }
}
