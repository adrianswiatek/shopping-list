import ShoppingList_Domain

public struct AddItemsToBasketCommand: Command {
    public let ids: [Id<Item>]
    public let source: CommandSource

    public init(_ ids: [Id<Item>]) {
        self.ids = ids
        self.source = .items
    }
}
