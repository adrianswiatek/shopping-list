import ShoppingList_Domain

public struct ItemInBasketViewModel: Hashable {
    public let uuid: UUID
    public let name: String

    public init(_ item: Item) {
        uuid = item.id.toUuid()
        name = item.name
    }
}
