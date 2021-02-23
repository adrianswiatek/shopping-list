public struct Item {
    public let id: Id<Item>
    public let name: String
    public let info: String?
    public let state: ItemState
    public let categoryId: Id<ItemsCategory>
    public let listId: Id<List>

    public init(
        id: Id<Item>,
        name: String,
        info: String?,
        state: ItemState,
        categoryId: Id<ItemsCategory>?,
        listId: Id<List>
    ) {
        self.id = id
        self.name = name
        self.info = info
        self.state = state
        self.categoryId = categoryId ?? ItemsCategory.default.id
        self.listId = listId
    }
    
    public static func toBuy(
        name: String,
        info: String?,
        listId: Id<List>,
        categoryId: Id<ItemsCategory>? = nil
    ) -> Item {
        self.init(
            id: .random(),
            name: name,
            info: info,
            state: .toBuy,
            categoryId: categoryId,
            listId: listId
        )
    }

    public func withChanged(state: ItemState) -> Item {
        Item(id: id, name: name, info: info, state: state, categoryId: categoryId, listId: listId)
    }

    public func withChanged(listId: Id<List>) -> Item {
        Item(id: id, name: name, info: info, state: state, categoryId: categoryId, listId: listId)
    }

    public func withChanged(categoryId: Id<ItemsCategory>) -> Item {
        Item(id: id, name: name, info: info, state: state, categoryId: categoryId, listId: listId)
    }
}
