public struct ModelItem {
    public let id: Id<ModelItem>
    public let name: String

    public init(id: Id<ModelItem>, name: String) {
        self.id = id
        self.name = name
    }

    public static func newWithName(_ name: String) -> ModelItem {
        .init(id: .random(), name: name)
    }

    public static func newFromItem(_ item: Item) -> ModelItem {
        .init(id: .random(), name: item.name)
    }

    public func withChanged(name: String) -> ModelItem {
        .init(id: id, name: name)
    }

    public func toItem(inListWithId listId: Id<List>) -> Item {
        .toBuy(name: name, info: nil, listId: listId)
    }
}
