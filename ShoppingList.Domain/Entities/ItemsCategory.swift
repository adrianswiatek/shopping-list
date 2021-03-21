import Foundation

public struct ItemsCategory: Hashable {
    public let id: Id<ItemsCategory>
    public let name: String
    public let itemsCount: Int

    public var isDefault: Bool {
        id == ItemsCategory.default.id
    }

    public static var `default`: ItemsCategory {
        .init(id: .fromUuid(Constant.defaultUuid), name: "", itemsCount: 0)
    }

    public init(id: Id<ItemsCategory>, name: String, itemsCount: Int = 0) {
        self.id = id
        self.name = name
        self.itemsCount = itemsCount
    }

    public func withName(_ name: String) -> ItemsCategory {
        .init(id: id, name: name, itemsCount: itemsCount)
    }

    public func withItemsCount(_ itemsCount: Int) -> ItemsCategory {
        .init(id: id, name: name, itemsCount: itemsCount)
    }

    public static func withName(_ name: String) -> ItemsCategory {
        .init(id: .random(), name: name, itemsCount: 0)
    }
}

private extension ItemsCategory {
    enum Constant {
        static let defaultUuid = UUID(uuidString: "a5ebf554-e318-48a4-b944-24eb450a4b46")!
    }
}
