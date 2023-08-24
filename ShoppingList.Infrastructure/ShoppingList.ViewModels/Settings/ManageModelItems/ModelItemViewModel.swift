import ShoppingList_Domain

public struct ModelItemViewModel: Hashable {
    public let uuid: UUID
    public let name: String

    public static var empty: ModelItemViewModel {
        .init(uuid: .init(), name: "")
    }

    private init(uuid: UUID, name: String) {
        self.uuid = uuid
        self.name = name
    }
}

extension ModelItemViewModel {
    public enum Factory {
        static func fromModelItem(_ modelItem: ModelItem) -> ModelItemViewModel {
            .init(uuid: modelItem.id.toUuid(), name: modelItem.name)
        }
    }
}
