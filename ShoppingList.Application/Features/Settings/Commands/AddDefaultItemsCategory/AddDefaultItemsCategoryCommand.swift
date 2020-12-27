public struct AddDefaultItemsCategoryCommand: CommandNew {
    public let source: CommandSource

    public init() {
        self.source = .categories
    }
}
