import Foundation

struct List {
    let id: UUID
    let name: String
    let accessType: ListAccessType
    let items: [Item]
    let updateDate: Date
    
    func getNumberOfItemsToBuy() -> Int {
        return items.filter { $0.state == .toBuy }.count
    }
    
    func getWithChanged(name: String) -> List {
        return List(id: self.id, name: name, accessType: self.accessType, items: self.items, updateDate: Date())
    }
    
    func getWithChanged(items: [Item]) -> List {
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    static func new(name: String) -> List {
        return List(id: UUID(), name: name, accessType: .private, items: [Item](), updateDate: Date())
    }
}
