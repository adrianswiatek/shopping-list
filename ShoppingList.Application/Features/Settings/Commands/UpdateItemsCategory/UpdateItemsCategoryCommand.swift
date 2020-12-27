import Foundation

public struct UpdateItemsCategoryCommand: CommandNew {
    public let id: UUID
    public let name: String
    public let source: CommandSource

    public init(_ id: UUID, _ name: String) {
        self.id = id
        self.name = name
        self.source = .categories
    }
}
