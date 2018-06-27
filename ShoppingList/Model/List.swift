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
    
    func getWithAdded(item: Item) -> List {
        var items = self.items
        items.append(item)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    func getWithRemoved(item: Item) -> List {
        var items = self.items
        guard let index = items.index(where: { $0.id == item.id }) else { return self }

        items.remove(at: index)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    func getWithChanged(item: Item) -> List {
        var items = self.items
        guard let index = items.index(where: { $0.id == item.id }) else { return self }
        
        items.remove(at: index)
        items.insert(item, at: index)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    func getWithChanged(items: [Item]) -> List {
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    static func new(name: String) -> List {
        return List(id: UUID(), name: name, accessType: .private, items: [Item](), updateDate: Date())
    }
}
