public struct ModelItem {
    public let id: Id<ModelItem>
    public let name: String
    public let categoryId: Id<ItemsCategory>?

    public init(id: Id<ModelItem>, name: String, categoryId: Id<ItemsCategory>?) {
        self.id = id
        self.name = name
        self.categoryId = categoryId
    }

    public static func newWithName(_ name: String) -> ModelItem {
        .init(id: .random(), name: name, categoryId: ItemsCategory.default.id)
    }

    public static func newFromName(_ item: Item) -> ModelItem {
        .init(id: .random(), name: item.name, categoryId: item.categoryId)
    }

    public func withChanged(name: String) -> ModelItem {
        .init(id: id, name: name, categoryId: categoryId)
    }

    public func withChanged(categoryId: Id<ItemsCategory>) -> ModelItem {
        .init(id: id, name: name, categoryId: categoryId)
    }

    public func toItem(inListWithId listId: Id<List>) -> Item {
        .toBuy(name: name, info: nil, listId: listId)
    }
}
