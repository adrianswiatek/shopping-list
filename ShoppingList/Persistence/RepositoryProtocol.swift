import Foundation

protocol RepositoryProtocol {
    
    // MARK: - List
    
    func getLists() -> [List]
    func getList(by id: UUID) -> List?
    func add(_ list: List)
    func update(_ list: List)
    func remove(_ list: List)
    
    // MARK: - Category
    
    func getCategories() -> [Category]
    func add(_ category: Category)
    func update(_ category: Category)
    func remove(_ category: Category)
    
    // MARK: - Item
    
    func getItems() -> [Item]
    func getItemsWith(state: ItemState, in list: List) -> [Item]
    func getNumberOfItemsWith(state: ItemState, in list: List) -> Int
    func getNumberOfItems(in list: List) -> Int
    func add(_ item: Item)
    func remove(_ items: [Item])
    func remove(_ item: Item)
    func updateState(of items: [Item], to state: ItemState)
    func updateState(of item: Item, to state: ItemState)
    func update(_ item: Item)
    func updateCategory(of item: Item, to category: Category)
    func updateCategory(of items: [Item], to category: Category)
    
    // MARK: - ItemsOrder
    
    func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState)
    
    // MARK: - Other
    
    func save()
}
