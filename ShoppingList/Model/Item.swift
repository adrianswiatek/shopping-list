import Foundation

public struct Item {
    public let id: UUID
    public let name: String
    public let info: String?
    public let state: ItemState
    public let category: Category?
    public let list: List
    
    public static func toBuy(name: String, info: String?, list: List, category: Category? = nil) -> Item {
        self.init(id: UUID(), name: name, info: info, state: .toBuy, category: category, list: list)
    }
    
    public func getCategoryName() -> String {
         getCategory().name
    }
    
    public func getCategory() -> Category {
        category ?? Category.getDefault()
    }
    
    public func getWithChanged(state: ItemState) -> Item {
        Item(id: id, name: name, info: info, state: state, category: category, list: list)
    }
    
    public func getWithChanged(category: Category) -> Item {
        Item(id: id, name: name, info: info, state: state, category: category, list: list)
    }
}
