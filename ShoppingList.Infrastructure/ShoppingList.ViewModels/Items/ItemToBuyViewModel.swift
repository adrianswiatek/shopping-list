import ShoppingList_Domain

public struct ItemToBuyViewModel {
    public let uuid: UUID
    public let name: String
    public let info: String
    public let categoryName: String

    public init(_ item: Item, _ category: ItemsCategory) {
        uuid = item.id.toUuid()
        name = item.name
        info = item.info ?? ""
        categoryName = category.name
    }
}
