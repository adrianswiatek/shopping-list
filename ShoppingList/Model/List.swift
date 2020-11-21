import Foundation

public struct List {
    public let id: UUID
    public let name: String
    public let accessType: ListAccessType
    public let items: [Item]
    public let updateDate: Date
    
    public func getNumberOfItemsToBuy() -> Int {
        return items.filter { $0.state == .toBuy }.count
    }
    
    public func getNumberOfItemsInBasket() -> Int {
        return items.filter { $0.state == .inBasket }.count
    }
    
    public func getWithChanged(name: String) -> List {
        return List(id: self.id, name: name, accessType: self.accessType, items: self.items, updateDate: Date())
    }

    public func with(accessType: ListAccessType) -> List {
        return List(id: self.id, name: self.name, accessType: accessType, items: self.items, updateDate: self.updateDate)
    }
    
    public func getWithAdded(item: Item) -> List {
        var items = self.items
        items.append(item)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    public func getWithAdded(items: [Item]) -> List {
        var currentItems = self.items
        currentItems.append(contentsOf: items)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: currentItems, updateDate: Date())
    }
    
    public func getWithTheSameUpdateDateAndWithAdded(items: [Item]) -> List {
        var currentItems = self.items
        currentItems.append(contentsOf: items)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: currentItems, updateDate: self.updateDate)
    }
    
    public func getWithRemoved(item: Item) -> List {
        var items = self.items
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return self }

        items.remove(at: index)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    public func getWithChanged(item: Item) -> List {
        var items = self.items
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return self }
        
        items.remove(at: index)
        items.insert(item, at: index)
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    public func getWithChanged(items: [Item]) -> List {
        return List(id: self.id, name: self.name, accessType: self.accessType, items: items, updateDate: Date())
    }
    
    public func getWithChangedDate() -> List {
        return List(id: self.id, name: self.name, accessType: self.accessType, items: self.items, updateDate: Date())
    }
    
    public static func new(name: String) -> List {
        return List(id: UUID(), name: name, accessType: .private, items: [Item](), updateDate: Date())
    }
}
