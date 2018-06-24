import Foundation

struct List {
    let id: UUID
    let name: String
    let accessType: ListAccessType
    let items: [Item]
    
    func getNumberOfItemsToBuy() -> Int {
        return items.filter { $0.state == .toBuy }.count
    }
    
    func getWithChanged(items: [Item]) -> List {
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items)
    }
    
    static func new(name: String) -> List {
        return List(id: UUID(), name: name, accessType: .private, items: [Item]())
    }
}
