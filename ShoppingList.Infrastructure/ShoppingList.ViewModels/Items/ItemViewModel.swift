import ShoppingList_Domain

public struct ItemViewModel {
    public let id: UUID
    public let name: String
    public let info: String
    public let categoryName: String

    public init(_ item: Item) {
        self.id = item.id.toUuid()
        self.name = item.name
        self.info = item.info ?? ""
        self.categoryName = item.categoryName()
    }
}
