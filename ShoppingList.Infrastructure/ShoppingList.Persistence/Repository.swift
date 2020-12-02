import ShoppingList_Domain
import Foundation

public final class Repository: RepositoryProtocol {
    public static let shared: Repository = Repository()
    
    private let repository: RepositoryProtocol
    
    private init() {
        repository = CoreDataRepository()
        //repository = InMemoryRepository()
    }
    
    // MARK: - List
    public func getLists() -> [List] { repository.getLists() }
    public func getList(by id: UUID) -> List? { repository.getList(by: id) }
    public func add(_ list: List) { repository.add(list) }
    public func update(_ list: List) { repository.update(list) }
    public func remove(by id: UUID) { repository.remove(by: id) }
    
    // MARK: - Category
    public func getCategories() -> [ItemsCategory] { repository.getCategories() }
    public func add(_ category: ItemsCategory) { repository.add(category) }
    public func update(_ category: ItemsCategory) { repository.update(category) }
    public func remove(_ category: ItemsCategory) { repository.remove(category) }

    // MARK: - Item
    public func getItems() -> [Item] { repository.getItems() }
    public func getItemsWith(state: ItemState, in list: List) -> [Item] { repository.getItemsWith(state: state, in: list) }
    public func getNumberOfItemsWith(state: ItemState, in list: List) -> Int { repository.getNumberOfItemsWith(state: state, in: list) }
    public func getNumberOfItems(in list: List) -> Int { repository.getNumberOfItems(in: list) }
    public func add(_ item: Item) { repository.add(item) }
    public func add(_ items: [Item]) { repository.add(items) }
    public func remove(_ items: [Item]) { repository.remove(items) }
    public func remove(_ item: Item) { repository.remove(item) }
    public func updateState(of items: [Item], to state: ItemState) { repository.updateState(of: items, to: state) }
    public func updateState(of item: Item, to state: ItemState) { repository.updateState(of: item, to: state) }
    public func update(_ item: Item) { repository.update(item) }
    public func updateCategory(of item: Item, to category: ItemsCategory) { repository.updateCategory(of: item, to: category) }
    public func updateCategory(of items: [Item], to category: ItemsCategory) { repository.updateCategory(of: items, to: category) }
    
    // MARK: - Items Order
    public func setItemsOrder(_ items: [Item], in list: List, forState state: ItemState) { repository.setItemsOrder(items, in: list, forState: state) }
    
    // MARK: - Other
    public func save() { repository.save() }
}

extension Repository {
    private var defaultCategoryNameKey: String {
        "DefaultCategoryName"
    }
    
    var defaultCategoryName: String {
        get { UserDefaults.standard.string(forKey: defaultCategoryNameKey) ?? "Other" }
        set { UserDefaults.standard.set(newValue, forKey: defaultCategoryNameKey) }
    }
}
