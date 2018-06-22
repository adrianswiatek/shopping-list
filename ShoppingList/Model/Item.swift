import Foundation

struct Item {
    let id: UUID
    let name: String
    let state: ItemState
    let category: Category?
    
    static func toBuy(name: String, category: Category? = nil) -> Item {
        return self.init(id: UUID(), name: name, state: .toBuy, category: category)
    }
    
    func getCategoryName() -> String {
        return getCategory().name
    }
    
    func getCategory() -> Category {
        return category ?? Category.getDefault()
    }
    
    func getWithChanged(state: ItemState) -> Item {
        return Item(id: self.id, name: self.name, state: state, category: self.category)
    }
    
    func getWithChanged(name: String) -> Item {
        return Item(id: self.id, name: name, state: self.state, category: self.category)
    }
    
    func getWithChanged(category: Category) -> Item {
        return Item(id: self.id, name: self.name, state: self.state, category: category)
    }
}
