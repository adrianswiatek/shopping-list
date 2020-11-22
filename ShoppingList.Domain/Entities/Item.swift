import Foundation

public struct Item {
    public let id: UUID
    public let name: String
    public let info: String?
    public let state: ItemState
    public let category: ItemsCategory
    public let list: List

    public init(id: UUID, name: String, info: String?, state: ItemState, category: ItemsCategory?, list: List) {
        self.id = id
        self.name = name
        self.info = info
        self.state = state
        self.category = category ?? .default
        self.list = list
    }
    
    public static func toBuy(name: String, info: String?, list: List, category: ItemsCategory? = nil) -> Item {
        self.init(id: UUID(), name: name, info: info, state: .toBuy, category: category, list: list)
    }
    
    public func categoryName() -> String {
         category.name
    }

    public func getWithChanged(state: ItemState) -> Item {
        Item(id: id, name: name, info: info, state: state, category: category, list: list)
    }
    
    public func getWithChanged(category: ItemsCategory) -> Item {
        Item(id: id, name: name, info: info, state: state, category: category, list: list)
    }
}
