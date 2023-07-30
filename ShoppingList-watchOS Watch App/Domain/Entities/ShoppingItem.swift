struct ShoppingItem {
    let id: Id<ShoppingItem>
    let listId: Id<ShoppingList>
    let name: String
    let category: String
    let state: State

    init(
        _ id: Id<ShoppingItem>,
        _ listId: Id<ShoppingList>,
        _ name: String,
        _ category: String,
        _ state: State
    ) {
        self.id = id
        self.listId = listId
        self.name = name
        self.category = category
        self.state = state
    }
}

extension ShoppingItem {
    enum State: String {
        case onList
        case inBasket
    }

    enum Field {
        case category(to: String)
        case listId(to: Id<ShoppingList>)
        case name(to: String)
        case state(to: State)
    }

    func updating(_ field: Field) -> ShoppingItem {
        switch field {
        case .category(let newCategory):
            return .init(id, listId, name, newCategory, state)
        case .listId(let newListId):
            return .init(id, newListId, name, category, state)
        case .name(let newName):
            return .init(id, listId, newName, category, state)
        case .state(let newState):
            return .init(id, listId, name, category, newState)
        }
    }

    func updating(_ fields: [Field]) -> ShoppingItem {
        fields.reduce(self) { $0.updating($1) }
    }
}
