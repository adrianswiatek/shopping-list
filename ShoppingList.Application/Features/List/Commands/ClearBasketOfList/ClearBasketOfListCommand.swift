public struct ClearBasketOfListCommand: CommandNew {
    public let id: UUID
    public let source: CommandSource

    public init(_ id: UUID) {
        self.id = id
        self.source = .lists
    }
}
