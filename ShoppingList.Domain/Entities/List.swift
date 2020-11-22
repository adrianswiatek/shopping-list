import Foundation

public struct List {
    public let id: UUID
    public let name: String
    public let accessType: ListAccessType
    public let items: [Item]
    public let updateDate: Date

    public init(id: UUID, name: String, accessType: ListAccessType, items: [Item], updateDate: Date = Date()) {
        self.id = id
        self.name = name
        self.accessType = accessType
        self.items = items
        self.updateDate = updateDate
    }

    public func numberOfItemsToBuy() -> Int {
        items.filter { $0.state == .toBuy }.count
    }
    
    public func numberOfItemsInBasket() -> Int {
        items.filter { $0.state == .inBasket }.count
    }
    
    public func withChangedName(_ name: String) -> List {
        List(id: id, name: name, accessType: accessType, items: items, updateDate: Date())
    }

    public func withAccessType(_ accessType: ListAccessType) -> List {
        List(id: id, name: name, accessType: accessType, items: items, updateDate: updateDate)
    }
    
    public func withAddedItem(_ item: Item) -> List {
        var items = self.items
        items.append(item)
        return List(id: id, name: name, accessType: accessType, items: items, updateDate: Date())
    }
    
    public func withAddedItems(_ items: [Item]) -> List {
        var currentItems = self.items
        currentItems.append(contentsOf: items)
        return List(id: id, name: name, accessType: accessType, items: currentItems, updateDate: Date())
    }
    
    public func withTheSameUpdateDateAndWithAddedItems(_ items: [Item]) -> List {
        var currentItems = self.items
        currentItems.append(contentsOf: items)
        return List(id: id, name: name, accessType: accessType, items: currentItems, updateDate: updateDate)
    }
    
    public func withRemovedItem(_ item: Item) -> List {
        var items = self.items
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return self }

        items.remove(at: index)
        return List(id: id, name: name, accessType: accessType, items: items, updateDate: Date())
    }
    
    public func withChangedItem(_ item: Item) -> List {
        var items = self.items
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return self }
        
        items.remove(at: index)
        items.insert(item, at: index)
        return List(id: id, name: name, accessType: accessType, items: items, updateDate: Date())
    }
    
    public func withChangedItems(_ items: [Item]) -> List {
        List(id: id, name: name, accessType: accessType, items: items, updateDate: Date())
    }
    
    public func withChangedDate() -> List {
        List(id: id, name: name, accessType: accessType, items: items, updateDate: Date())
    }
    
    public static func withName(_ name: String) -> List {
        List(id: UUID(), name: name, accessType: .private, items: [Item](), updateDate: Date())
    }
}
