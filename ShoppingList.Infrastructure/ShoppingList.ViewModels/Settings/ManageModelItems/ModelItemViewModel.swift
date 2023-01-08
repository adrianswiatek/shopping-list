import ShoppingList_Domain

public struct ModelItemViewModel: Hashable {
    public let uuid: UUID
    public let name: String
    public let categoryName: String

    public static var empty: ModelItemViewModel {
        .init(uuid: .init(), name: "", categoryName: "")
    }

    private init(uuid: UUID, name: String, categoryName: String) {
        self.uuid = uuid
        self.name = name
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
                .map { (modelItem.id.toUuid(), modelItem.name, $0.name)}
                .map(ModelItemViewModel.init)
        }
    }
}
