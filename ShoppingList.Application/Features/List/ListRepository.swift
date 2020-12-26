import ShoppingList_Domain

public protocol ListRepository {
    func allLists() -> [List]
    func list(by id: UUID) -> List?
    func add(_ list: List)
    func update(_ list: List)
    func remove(by id: UUID)
}
