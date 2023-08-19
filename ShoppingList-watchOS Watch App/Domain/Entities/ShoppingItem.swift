import Foundation

struct ShoppingItem {
    let id: Id<ShoppingItem>
    let listId: Id<ShoppingList>
    let name: String
    let category: String
    let state: State
    let lastChange: Date

    init(
        _ id: Id<ShoppingItem>,
        _ listId: Id<ShoppingList>,
        _ name: String,
        _ category: String,
        _ state: State,
        _ lastChange: Date
    ) {
        self.id = id
        self.listId = listId
        self.name = name
        self.category = category
        self.state = state
        self.lastChange = lastChange
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
            return .init(id, listId, name, newCategory, state, Date())
        case .listId(let newListId):
            return .init(id, newListId, name, category, state, Date())
        case .name(let newName):
            return .init(id, listId, newName, category, state, Date())
        case .state(let newState):
            return .init(id, listId, name, category, newState, Date())
        }
    }

    func updating(_ fields: [Field]) -> ShoppingItem {
        fields.reduce(self) { $0.updating($1) }
    }
}
