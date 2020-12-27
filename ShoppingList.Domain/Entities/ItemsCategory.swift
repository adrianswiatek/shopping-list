import Foundation

public struct ItemsCategory: Hashable {
    public let id: UUID
    public let name: String

    public var isDefault: Bool {
        id == ItemsCategory.default.id
    }

    public static var `default`: ItemsCategory {
        .init(id: Constant.defaultUuid, name: "")
    }

    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    public func withName(_ name: String) -> ItemsCategory {
        .init(id: id, name: name)
    }
    
    public static func withName(_ name: String) -> ItemsCategory {
        .init(id: UUID(), name: name)
    }
}

private extension ItemsCategory {
    enum Constant {
        static let defaultUuid = UUID(uuidString: "a5ebf554-e318-48a4-b944-24eb450a4b46")!
    }
}
