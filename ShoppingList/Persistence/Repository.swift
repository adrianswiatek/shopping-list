class Repository: RepositoryProtocol {

    static let shared: Repository = Repository()
    
    private let repository: RepositoryProtocol
    
    private init() {
        repository = CoreDataRepository()
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
    
    func save() {
        repository.save()
    }
}
