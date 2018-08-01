import Foundation

struct Item {
    let id: UUID
    let name: String
    let info: String?
    let state: ItemState
    let category: Category?
    let list: List
    
    static func toBuy(name: String, info: String?, list: List, category: Category? = nil) -> Item {
        return self.init(id: UUID(), name: name, info: info, state: .toBuy, category: category, list: list)
    }
    
    func getCategoryName() -> String {
        return getCategory().name
    }
    
    func getCategory() -> Category {
        return category ?? Category.getDefault()
    }
    
    func getWithChanged(state: ItemState) -> Item {
        return Item(id: id, name: name, info: info, state: state, category: category, list: list)
    }
    
    func getWithChanged(category: Category) -> Item {
        return Item(id: id, name: name, info: info, state: state, category: category, list: list)
    }
}
