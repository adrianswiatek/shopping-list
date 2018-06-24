import Foundation

struct Item {
    let id: UUID
    let name: String
    let state: ItemState
    let category: Category?
    let list: List
    
    static func toBuy(name: String, list: List, category: Category? = nil) -> Item {
        return self.init(id: UUID(), name: name, state: .toBuy, category: category, list: list)
    }
    
    func getCategoryName() -> String {
        return getCategory().name
    }
    
    func getCategory() -> Category {
        return category ?? Category.getDefault()
    }
    
    func getWithChanged(state: ItemState) -> Item {
        return Item(id: self.id, name: self.name, state: state, category: self.category, list: self.list)
    }
    
    func getWithChanged(name: String) -> Item {
        return Item(id: self.id, name: name, state: self.state, category: self.category, list: self.list)
    }
    
    func getWithChanged(category: Category) -> Item {
        return Item(id: self.id, name: self.name, state: self.state, category: category, list: self.list)
    }
}
