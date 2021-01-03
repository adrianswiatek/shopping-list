import ShoppingList_Domain

public struct ItemsCategoryViewModel: Hashable {
    public let id: UUID
    public let name: String
    public let isDefault: Bool
    public let itemsInCategory: Int

    public init(_ itemsCategory: ItemsCategory) {
        id = itemsCategory.id.toUuid()
        name = itemsCategory.name
        isDefault = itemsCategory.isDefault
        itemsInCategory = 0
    }
}
