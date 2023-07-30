struct ShoppingListDto: Decodable, DictionaryDecodable {
    let id: String
    let name: String

    func toShoppingList() -> ShoppingList {
        let listId: Id<ShoppingList> = .fromString(id)
        return ShoppingList(listId, name)
    }

    static func fromDictionary(_ dictionary: [String: Any]) -> ShoppingListDto? {
        let id = dictionary["id"] as? String
        let name = dictionary["name"] as? String

        guard let id, let name else {
            return nil
        }

        return ShoppingListDto(id: id, name: name)
    }
}
