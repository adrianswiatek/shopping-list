import ShoppingList_Domain

public struct ModelItemViewModel: Hashable {
    public let uuid: UUID
    public let name: String
    public let categoryName: String

    private init(_ modelItem: ModelItem, categoryName: String) {
        self.uuid = modelItem.id.toUuid()
        self.name = modelItem.name
        self.categoryName = categoryName
    }
}

extension ModelItemViewModel {
    public enum Factory {
        static func fromModelItem(
            _ modelItem: ModelItem,
            categories: [ItemsCategory]
        ) -> ModelItemViewModel? {
            categories
                .first { $0.id == modelItem.categoryId }
                .map { .init(modelItem, categoryName: $0.name) }
        }
    }
}
