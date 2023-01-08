import ShoppingList_Domain

public final class ModelItemService: ModelItemQueries {
    private let modelItemRepository: ModelItemRepository

    public init(_ modelItemRepository: ModelItemRepository) {
        self.modelItemRepository = modelItemRepository
    }

    public func fetchModelItems(_ sortingStrategy: SortingStrategy) -> [ModelItem] {
        modelItemRepository.allModelItems().sorted(by: sortingStrategy.run)
    }
}

extension ModelItemService {
    public struct SortingStrategy {
        public let run: (ModelItem, ModelItem) -> Bool

        private init(_ run: @escaping (ModelItem, ModelItem) -> Bool) {
            self.run = run
        }

        public static func inAlphabeticalOrder() -> SortingStrategy {
            .init { $0.name < $1.name }
        }

        public static func inReversedAlphabeticalOrder() -> SortingStrategy {
            .init { $0.name > $1.name }
        }
    }
}
