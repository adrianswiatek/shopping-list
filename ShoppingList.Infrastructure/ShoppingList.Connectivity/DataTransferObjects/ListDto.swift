import ShoppingList_Domain

public struct ListDto: Encodable, DictionaryEncodable {
    public let id: String
    public let name: String

    private init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    public static var make: (List) -> ListDto {
        return { list in
            .init(id: list.id.toString(), name: list.name)
        }
    }

    public func toDictionary() -> [String: Any] {
        ["id": id, "name": name]
    }
}
