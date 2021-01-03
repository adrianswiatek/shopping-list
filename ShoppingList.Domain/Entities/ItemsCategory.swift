import Foundation

public struct ItemsCategory: Hashable {
    public let id: Id<Category>
    public let name: String

    public var isDefault: Bool {
        id == ItemsCategory.default.id
    }

    public static var `default`: ItemsCategory {
        .init(id: .fromUuid(Constant.defaultUuid), name: "")
    }

    public init(id: Id<Category>, name: String) {
        self.id = id
        self.name = name
    }
    
    public func withName(_ name: String) -> ItemsCategory {
        .init(id: id, name: name)
    }
    
    public static func withName(_ name: String) -> ItemsCategory {
        .init(id: .random(), name: name)
    }
}

private extension ItemsCategory {
    enum Constant {
        static let defaultUuid = UUID(uuidString: "a5ebf554-e318-48a4-b944-24eb450a4b46")!
    }
}
