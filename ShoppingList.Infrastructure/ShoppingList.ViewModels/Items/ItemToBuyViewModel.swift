import ShoppingList_Domain

public struct ItemToBuyViewModel: Hashable {
    public let uuid: UUID

    public let name: String
    public let info: String

    public let externalUrl: String?
    public let hasExternalUrl: Bool

    public let categoryName: String

    public init(_ item: Item, _ category: ItemsCategory) {
        uuid = item.id.toUuid()

        name = item.name
        info = item.info ?? ""

        externalUrl = item.externalUrl?.absoluteString
        hasExternalUrl = externalUrl.map { $0.isNotEmpty } == true

        categoryName = category.name
    }
}
