protocol RepositoryProtocol {
    func getCategories() -> [Category]
    func add(_ category: Category)
    func update(_ category: Category)
    func remove(_ category: Category)
    
    func getItems() -> [Item]
    func getItemsWith(state: ItemState) -> [Item]
    func add(_ item: Item)
    func remove(_ items: [Item])
    func remove(_ item: Item)
    func updateState(of items: [Item], to state: ItemState)
    func updateState(of item: Item, to state: ItemState)
    func update(_ item: Item)
    func updateCategory(of item: Item, to category: Category)
    func updateCategory(of items: [Item], to category: Category)
    
    func setItemsOrder(_ items: [Item], forState state: ItemState)
    
    func save()
}
