import ShoppingList_Domain

public struct AddItemsToBasketCommand: CommandNew {
    public let ids: [Id<Item>]
    public let source: CommandSource

    public init(_ ids: [Id<Item>]) {
        self.ids = ids
        self.source = .items
    }
}
