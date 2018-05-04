import Foundation

struct Category {
    let id: UUID
    let name: String
    
    private init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    static func new(name: String) -> Category {
        return Category(id: UUID(), name: name)
    }
}
