import ShoppingList_Domain

public struct ItemsCategoryViewModel: Hashable {
    public let uuid: UUID
    public let name: String
    public let isDefault: Bool
    public let itemsInCategory: Int

    public init(_ itemsCategory: ItemsCategory) {
        uuid = itemsCategory.id.toUuid()
        name = itemsCategory.name
        isDefault = itemsCategory.isDefault
        itemsInCategory = 0
    }
}
