import Foundation

struct List {
    let id: UUID
    let name: String
    let accessType: ListAccessType
    let items: [Item]
    
    static func new(name: String) -> List {
        return List(id: UUID(), name: name, accessType: .private, items: [Item]())
    }
}
