public struct AddDefaultItemsCategoryCommand: Command {
    public let source: CommandSource

    public init() {
        self.source = .categories
    }
}
