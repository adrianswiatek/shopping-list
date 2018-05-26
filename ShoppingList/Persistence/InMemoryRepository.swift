import Foundation

class InMemoryRepository: RepositoryProtocol {
    
    private var items = [Item]()
    
    init() {
        let fruitsCategory = Category.new(name: "Fruits")
        items.append(Item.toBuy(name: "Avocado", category: fruitsCategory))
        items.append(Item.toBuy(name: "Bananas", category: fruitsCategory))
        items.append(Item.toBuy(name: "Blackberries", category: fruitsCategory))
        items.append(Item.toBuy(name: "Apples", category: fruitsCategory))
        
        let dairyCategory = Category.new(name: "Dairy")
        items.append(Item.toBuy(name: "Milk", category: dairyCategory))
        items.append(Item.toBuy(name: "Yogurt", category: dairyCategory))
        
        let vegetablesCategory = Category.new(name: "Vegetables")
        items.append(Item.toBuy(name: "Carrots", category: vegetablesCategory))
        items.append(Item.toBuy(name: "Spinach", category: vegetablesCategory))
        items.append(Item.toBuy(name: "Kale", category: vegetablesCategory))
    }

    func getItemsWith(state: ItemState) -> [Item] {
        return items.filter { $0.state == state }
    }
    
    func add(_ item: Item) {
        items.insert(item, at: 0)
    }
    
    func remove(_ items: [Item]) {
        for item in items {
            remove(item)
        }
    }
    
    func remove(_ item: Item) {
        if let index = self.items.index(where: { $0.id == item.id }) {
            self.items.remove(at: index)
        }
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        for item in items {
            updateState(of: item, to: state)
        }
    }
    
    func updateState(of item: Item, to state: ItemState) {
        if let index = self.items.index(where: { $0.id == item.id }) {
            self.items.remove(at: index)
            self.items.insert(item.getWithChanged(state: state), at: 0)
        }
    }
    
    func save() {}
}
