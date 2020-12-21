public struct AddItemsCategoryCommand: CommandNew {
    public let name: String
    public let source: CommandSource

    public init(_ name: String) {
        self.name = name
        self.source = .categories
    }
}
