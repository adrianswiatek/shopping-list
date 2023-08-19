struct UpdateListDto: Decodable, DictionaryDecodable {
    let list: ShoppingListDto
    let items: [ShoppingItemDto]

    func toEntities() -> (ShoppingList, [ShoppingItem]) {
        (list.toShoppingList(), items.map { $0.toShoppingItem(listId: list.id) })
    }

    func filteringItems(_ isIncluded: (ShoppingItemDto) -> Bool) -> UpdateListDto {
        UpdateListDto(list: list, items: items.filter(isIncluded))
    }

    static func fromDictionary(_ dictionary: [String: Any]) -> UpdateListDto? {
        let listDictionary = dictionary["list"] as? [String: Any]
        let list = listDictionary.flatMap(ShoppingListDto.fromDictionary)

        let itemsDictionary = dictionary["items"] as? [[String: Any]]
        let items = itemsDictionary?.compactMap(ShoppingItemDto.fromDictionary)

        guard let list, let items else {
            return nil
        }

        return UpdateListDto(list: list, items: items)
    }
}
