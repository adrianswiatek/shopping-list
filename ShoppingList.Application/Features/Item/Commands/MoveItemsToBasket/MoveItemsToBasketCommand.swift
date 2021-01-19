import ShoppingList_Domain

public struct MoveItemsToBasketCommand: Command {
    public let ids: [Id<Item>]
    public let source: CommandSource

    public init(_ uuids: [UUID]) {
        self.ids = uuids.map { .fromUuid($0) }
        self.source = .items
    }

    public func reversed() -> Command? {
        MoveItemsToListCommand(ids.map { $0.toUuid() })
    }
}
