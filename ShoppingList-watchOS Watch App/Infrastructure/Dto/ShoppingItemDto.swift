import Foundation

struct ShoppingItemDto: Decodable, DictionaryDecodable {
    let id: String
    let name: String
    let category: String
    let inBasket: Bool
    let lastChange: Date

    func toShoppingItem(listId: String) -> ShoppingItem {
        let itemId: Id<ShoppingItem> = .fromString(id)
        let listId: Id<ShoppingList> = .fromString(listId)
        let state: ShoppingItem.State = inBasket ? .inBasket : .onList

        return ShoppingItem(itemId, listId, name, category, state, lastChange)
    }

    static func fromDictionary(_ dictionary: [String: Any]) -> ShoppingItemDto? {
        let id = dictionary["id"] as? String
        let name = dictionary["name"] as? String
        let category = dictionary["category"] as? String
        let inBasket = dictionary["inBasket"] as? Bool
        let lastChange = dictionary["lastChange"] as? Date ?? Date()

        guard let id, let name, let category, let inBasket else {
            return nil
        }

        return ShoppingItemDto(
            id: id,
            name: name,
            category: category,
            inBasket: inBasket,
            lastChange: lastChange
        )
    }
}
