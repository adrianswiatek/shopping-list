struct ShoppingList {
    let id: Id<ShoppingList>
    let name: String
    let visited: Bool

    init(
        id: Id<ShoppingList>,
        name: String,
        visited: Bool
    ) {
        self.id = id
        self.name = name
        self.visited = visited
    }

    func visiting() -> ShoppingList {
        updating(.visited(to: true))
    }
}

extension ShoppingList {
    enum Field {
        case name(to: String)
        case visited(to: Bool)
    }

    func updating(_ field: Field) -> ShoppingList {
        switch field {
        case .name(let name):
            return ShoppingList(id: id, name: name, visited: visited)
        case .visited(let visited):
            return ShoppingList(id: id, name: name, visited: visited)
        }
    }

    func updating(_ fields: [Field]) -> ShoppingList {
        fields.reduce(self) { $0.updating($1) }
    }
}
