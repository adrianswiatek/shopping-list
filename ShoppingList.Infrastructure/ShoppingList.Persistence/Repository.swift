import Foundation

final class Repository: RepositoryProtocol {
    static let shared: Repository = Repository()
    
    private let repository: RepositoryProtocol
    
    private init() {
        repository = CoreDataRepository()
        //repository = InMemoryRepository()
    }
    
    // MARK: - List
    func getLists() -> [List] { repository.getLists() }
    func getList(by id: UUID) -> List? { repository.getList(by: id) }
    func add(_ list: List) { repository.add(list) }
    func update(_ list: List) { repository.update(list) }
    func remove(_ list: List) { repository.remove(list) }
    
    // MARK: - Category
    func getCategories() -> [Category] { repository.getCategories() }
    func add(_ category: Category) { repository.add(category) }
    func update(_ category: Category) { repository.update(category) }
    func remove(_ category: Category) { repository.remove(category) }

    // MARK: - Item
    func getItems() -> [Item] { repository.getItems() }
    func getItemsWith(state: ItemState, in list: List) -> [Item] { repository.getItemsWith(state: state, in: list) }
    func getNumberOfItemsWith(state: ItemState, in list: List) -> Int { repository.getNumberOfItemsWith(state: state, in: list) }
    func getNumberOfItems(in list: List) -> Int { repository.getNumberOfItems(in: list) }
    func add(_ item: Item) { repository.add(item) }
    func add(_ items: [Item]) { repository.add(items) }
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

extension Repository {
    private var defaultCategoryNameKey: String {
        return "DefaultCategoryName"
    }
    
    var defaultCategoryName: String {
        get { return UserDefaults.standard.string(forKey: defaultCategoryNameKey) ?? "Other" }
        set { UserDefaults.standard.set(newValue, forKey: defaultCategoryNameKey) }
    }
}