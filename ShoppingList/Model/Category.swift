import Foundation

struct Category: Hashable {
    let id: UUID
    let name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    func getWithChanged(name: String) -> Category {
        return Category(id: self.id, name: name)
    }
 
    func isDefault() -> Bool {
        return id == Category.getDefault().id
    }
    
    static func new(name: String) -> Category {
        return Category(id: UUID(), name: name)
    }
    
    static func getDefault() -> Category {
        let defaultUUID = UUID(uuidString: "a5ebf554-e318-48a4-b944-24eb450a4b46")!
        let defaultName = "Other"
        return Category(id: defaultUUID, name: defaultName)
    }
}
