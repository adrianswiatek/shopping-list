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
    
    func getNumberOfItemsInBasket() -> Int {
        return items.filter { $0.state == .inBasket }.count
    }
    
    func getWithChanged(name: String) -> List {
        return List(id: self.id, name: name, accessType: self.accessType, items: self.items, updateDate: Date())
    }

    func with(accessType: ListAccessType) -> List {
        return List(id: self.id, name: self.name, accessType: accessType, items: self.items, updateDate: self.updateDate)
    }
    
    func getWithAdded(item: Item) -> List {
        var items = self.items
        items.append(item)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    func getWithAdded(items: [Item]) -> List {
        var currentItems = self.items
        currentItems.append(contentsOf: items)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: currentItems, updateDate: Date())
    }
    
    func getWithTheSameUpdateDateAndWithAdded(items: [Item]) -> List {
        var currentItems = self.items
        currentItems.append(contentsOf: items)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: currentItems, updateDate: self.updateDate)
    }
    
    func getWithRemoved(item: Item) -> List {
        var items = self.items
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return self }

        items.remove(at: index)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    func getWithChanged(item: Item) -> List {
        var items = self.items
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return self }
        
        items.remove(at: index)
        items.insert(item, at: index)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    func getWithChanged(items: [Item]) -> List {
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    func getWithChangedDate() -> List {
        return List(id: self.id, name: self.name, accessType: self.accessType, items: self.items, updateDate: Date())
    }
    
    static func new(name: String) -> List {
        return List(id: UUID(), name: name, accessType: .private, items: [Item](), updateDate: Date())
    }
}
