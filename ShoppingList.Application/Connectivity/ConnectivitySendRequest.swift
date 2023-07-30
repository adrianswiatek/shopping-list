import ShoppingList_Domain

public struct ConnectivitySendRequest {
    public let list: List
    public let items: [Item]
    public let categories: [ItemsCategory]

    private init(list: List, items: [Item], categories: [ItemsCategory]) {
        self.list = list
        self.items = items
        self.categories = categories
    }

    public static var make: (List) -> ([Item]) -> ([ItemsCategory]) -> Self {
        return { list in
            return { items in
                return { categories in
                    .init(list: list, items: items, categories: categories)
                }
            }
        }
    }
}
