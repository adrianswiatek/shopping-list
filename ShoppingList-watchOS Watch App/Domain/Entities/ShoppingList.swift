struct ShoppingList {
    let id: Id<ShoppingList>
    let name: String

    init(
        _ id: Id<ShoppingList>,
        _ name: String
    ) {
        self.id = id
        self.name = name
    }
}

extension ShoppingList {
    enum Field {
        case name(to: String)
    }

    func updating(_ field: Field) -> ShoppingList {
        switch field {
        case .name(let newName):
            return ShoppingList(id, newName)
        }
    }

    func updating(_ fields: [Field]) -> ShoppingList {
        fields.reduce(self) { $0.updating($1) }
    }
}
