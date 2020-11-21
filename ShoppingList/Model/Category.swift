import Foundation

public struct Category: Hashable {
    public let id: UUID
    public let name: String
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    public func getWithChanged(name: String) -> Category {
        Category(id: id, name: name)
    }
 
    public func isDefault() -> Bool {
        id == Category.getDefault().id
    }
    
    public static func new(name: String) -> Category {
        return Category(id: UUID(), name: name)
    }
    
    public static func getDefault() -> Category {
        let defaultUUID = UUID(uuidString: "a5ebf554-e318-48a4-b944-24eb450a4b46")!
        let defaultName = Repository.shared.defaultCategoryName
        return Category(id: defaultUUID, name: defaultName)
    }
}
