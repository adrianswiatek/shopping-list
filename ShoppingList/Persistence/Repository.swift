import Foundation

class Repository: RepositoryProtocol {
    
    static let shared: Repository = Repository()
    
    private let repository: RepositoryProtocol
    
    private init() {
        repository = CoreDataRepository()
        //repository = InMemoryRepository()
    }
    
    // MARK: - List
    
    func getLists() -> [List] { return repository.getLists() }
    func getList(by id: UUID) -> List? { return repository.getList(by: id) }
    func add(_ list: List) { repository.add(list) }
    func update(_ list: List) { repository.update(list) }
    func remove(_ list: List) { repository.remove(list) }
    
    // MARK: - Category
    
    func getCategories() -> [Category] { return repository.getCategories() }
    func add(_ category: Category) { return repository.add(category) }
    func update(_ category: Category) { return repository.update(category) }
    func remove(_ category: Category) { return repository.remove(category) }

    // MARK: - Item
    func getItems() -> [Item] { return repository.getItems() }
    func getItemsWith(state: ItemState, in list: List) -> [Item] { return repository.getItemsWith(state: state, in: list) }
    func add(_ item: Item) { repository.add(item) }
    func remove(_ items: [Item]) { repository.remove(items) }
    func remove(_ item: Item) { repository.remove(item) }
    func updateState(of items: [Item], to state: ItemState) { repository.updateState(of: items, to: state) }
    func updateState(of item: Item, to state: ItemState) { repository.updateState(of: item, to: state) }
    func update(_ item: Item) { repository.update(item) }
    func updateCategory(of item: Item, to category: Category) { repository.updateCategory(of: item, to: category) }
    func updateCategory(of items: [Item], to category: Category) { repository.updateCategory(of: items, to: category) }
    
    // MARK: - Items Order
    func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState) { repository.setItemsOrder(items, in: list, forState: state) }
    
    // MARK: - Other
    func save() { repository.save() }
}
