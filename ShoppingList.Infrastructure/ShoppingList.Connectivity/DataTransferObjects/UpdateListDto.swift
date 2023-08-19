struct UpdateListDto: Encodable, DictionaryEncodable {
    let list: ListDto
    let items: [ItemDto]

    private init(list: ListDto, items: [ItemDto]) {
        self.list = list
        self.items = items
    }

    static var make: (ListDto) -> ([ItemDto]) -> UpdateListDto {
        return { list in
            return { items in
                UpdateListDto(list: list, items: items)
            }
        }
    }

    func toDictionary() -> [String: Any] {
        ["list": list.toDictionary(), "items": items.map { $0.toDictionary() }]
    }
}
