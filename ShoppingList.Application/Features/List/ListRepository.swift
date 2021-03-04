import ShoppingList_Domain

public protocol ListRepository {
    func allLists() -> [List]
    func list(with id: Id<List>) -> List?
    func add(_ list: List)
    func update(_ list: List)
    func remove(by id: Id<List>)
    func removeAll()
}
