import Foundation

class Repository {
    
    private static var items = [
        Item.toBuy(name: "bananas"),
        Item.toBuy(name: "newspaper"),
        Item.toBuy(name: "food for dog"),
        Item.toBuy(name: "vacuum cleaner")
    ]
    
    class ItemsToBuy {
        static var count: Int {
            return getAll().count
        }

        public static func getAll() -> [Item] {
            return items.filter { $0.state == .toBuy }
        }
        
        public static func getItem(at index: Int) -> Item? {
            return getAll()[index]
        }
        
        public static func getIndexOf(_ item: Item) -> Int? {
            return getAll().index { $0.id == item.id }
        }
        
        public static func moveItemToBasket(_ item: Item) {
            let itemToMove = remove(item: item)
            if let itemInBasket = itemToMove?.getWithChanged(state: .inBasket) {
                addNew(item: itemInBasket)
            }
        }
    }

    class ItemsInBasket {
        static var count: Int {
            return getAll().count
        }
        
        public static func getAll() -> [Item] {
            return items.filter { $0.state == .inBasket }
        }
        
        public static func moveItemFromBasket(_ item: Item) {
            let itemToMove = remove(item: item)
            if let itemInBasket = itemToMove?.getWithChanged(state: .toBuy) {
                addNew(item: itemInBasket)
            }
        }
    }
    
    public static func addNew(item: Item) {
        items.insert(item, at: 0)
    }
    
    @discardableResult
    public static func remove(item: Item) -> Item? {
        guard let index = items.index(where: { $0.id == item.id }) else {
            return nil
        }
        return items.remove(at: index)
    }
    
    @discardableResult
    public static func remove(at index: Int) -> Item? {
        return items.remove(at: index)
    }
}
