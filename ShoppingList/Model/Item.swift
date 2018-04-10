import Foundation

struct Item {
    let id: UUID
    let name: String
    let state: ItemState
    
    private init(id: UUID, name: String, state: ItemState) {
        self.id = id
        self.name = name
        self.state = state
    }
    
    static func toBuy(name: String) -> Item {
        return self.init(id: UUID(), name: name, state: .toBuy)
    }
}

extension Item {
    func getWithChanged(state: ItemState) -> Item {
        return Item(id: self.id, name: self.name, state: state)
    }
    
    func getWithChanged(name: String) -> Item {
        return Item(id: self.id, name: name, state: self.state)
    }
}
