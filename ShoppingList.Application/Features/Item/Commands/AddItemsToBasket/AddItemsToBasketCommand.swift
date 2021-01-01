public struct AddItemsToBasketCommand: CommandNew {
    public let ids: [UUID]
    public let source: CommandSource

    public init(_ ids: [UUID]) {
        self.ids = ids
        self.source = .items
    }
}
