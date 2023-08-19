import ShoppingList_Domain

public struct ItemDto: Encodable, DictionaryEncodable {
    public let id: String
    public let name: String
    public let category: String
    public let inBasket: Bool

    private init(id: String, name: String, category: String, inBasket: Bool) {
        self.id = id
        self.name = name
        self.category = category
        self.inBasket = inBasket
    }

    public static var make: (Item) -> (ItemsCategory) -> ItemDto {
        return { item in
            return { category in
                assert(item.categoryId == category.id)

                return ItemDto(
                    id: item.id.toString(),
                    name: item.name,
                    category: category.name,
                    inBasket: item.state == .inBasket
                )
            }
        }
    }

    public func toDictionary() -> [String: Any] {
        ["id": id, "name": name, "category": category, "inBasket": inBasket]
    }
}

extension Array where Element == ItemDto {
    static var make: ([Item]) -> ([ItemsCategory]) -> [ItemDto] {
        return { items in
            return { categories in
                let categoryForItem: (Item) -> ItemsCategory = { item in
                    categories.first { $0.id == item.categoryId } ?? .default
                }

                return items.map { item in
                    .make(item)(categoryForItem(item))
                }
            }
        }
    }
}
