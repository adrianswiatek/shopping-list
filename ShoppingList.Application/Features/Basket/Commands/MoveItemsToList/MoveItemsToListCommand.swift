import ShoppingList_Domain

public struct MoveItemsToListCommand: Command {
    public let ids: [Id<Item>]
    public let source: CommandSource

    public init(_ uuids: [UUID]) {
        self.ids = uuids.map { .fromUuid($0) }
        self.source = .basket
    }

    public func reversed() -> Command? {
        guard !ids.isEmpty else { return nil }
        return MoveItemsToBasketCommand(ids.map { $0.toUuid() })
    }
}
