public struct Item {
    public let id: Id<Item>
    public let name: String
    public let info: String?
    public let state: ItemState
    public let categoryId: Id<ItemsCategory>
    public let listId: Id<List>
    public let externalUrl: URL?

    public init(
        id: Id<Item>,
        name: String,
        info: String?,
        state: ItemState,
        categoryId: Id<ItemsCategory>?,
        listId: Id<List>,
        externalUrl: URL?
    ) {
        self.id = id
        self.name = name
        self.info = info
        self.state = state
        self.categoryId = categoryId ?? ItemsCategory.default.id
        self.listId = listId
        self.externalUrl = externalUrl
    }
    
    public static func toBuy(
        name: String,
        info: String?,
        listId: Id<List>,
        categoryId: Id<ItemsCategory>? = nil,
        externalUrl: URL? = nil
    ) -> Item {
        self.init(
            id: .random(),
            name: name,
            info: info,
            state: .toBuy,
            categoryId: categoryId,
            listId: listId,
            externalUrl: externalUrl
        )
    }

    public func withChanged(_ field: Field) -> Item {
        var categoryId: Id<ItemsCategory> = categoryId
        var externalUrl: URL? = externalUrl
        var listId: Id<List> = listId
        var state: ItemState = state

        switch field {
        case .categoryId(let id): categoryId = id
        case .externalUrl(let url): externalUrl = url
        case .listId(let id): listId = id
        case .state(let itemsState): state = itemsState
        }

        return Item(
            id: id,
            name: name,
            info: info,
            state: state,
            categoryId: categoryId,
            listId: listId,
            externalUrl: externalUrl
        )
    }
}

extension Item {
    public enum Field {
        case categoryId(Id<ItemsCategory>)
        case externalUrl(URL?)
        case listId(Id<List>)
        case state(ItemState)
    }
}
