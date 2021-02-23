public struct AddItemsCategoryCommand: Command {
    public let source: CommandSource

    internal let name: String

    public init(_ name: String) {
        self.name = name
        self.source = .categories
    }
}
