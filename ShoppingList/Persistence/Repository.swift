class Repository: RepositoryProtocol {

    static let shared: Repository = Repository()
    
    private let repository: RepositoryProtocol
    
    private init() {
//        repository = CoreDataRepository()
        repository = InMemoryRepository()
    }
    
    func getCategories() -> [Category] {
        return repository.getCategories()
    }
    
    func add(_ category: Category) {
        return repository.add(category)
    }
    
    func update(_ category: Category) {
        return repository.update(category)
    }
    
    func remove(_ category: Category) {
        return repository.remove(category)
    }
    
    func getItems() -> [Item] {
        return repository.getItems()
    }
    
    func getItemsWith(state: ItemState) -> [Item] {
        return repository.getItemsWith(state: state)
    }
    
    func add(_ item: Item) {
        repository.add(item)
    }
    
    func remove(_ items: [Item]) {
        repository.remove(items)
    }
    
    func remove(_ item: Item) {
        repository.remove(item)
    }
    
    func updateState(of items: [Item], to state: ItemState) {
        repository.updateState(of: items, to: state)
    }
    
    func updateState(of item: Item, to state: ItemState) {
        repository.updateState(of: item, to: state)
    }
    
    func update(_ item: Item) {
        repository.update(item)
    }
    
    func updateCategory(of item: Item, to category: Category) {
        repository.updateCategory(of: item, to: category)
    }
    
    func updateCategory(of items: [Item], to category: Category) {
        repository.updateCategory(of: items, to: category)
    }
    
    func setItemsOrder(_ items: [Item], forState state: ItemState) {
        repository.setItemsOrder(items, forState: state)
    }
    
    func save() {
        repository.save()
    }
}
