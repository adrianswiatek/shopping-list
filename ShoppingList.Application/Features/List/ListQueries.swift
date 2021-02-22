import ShoppingList_Domain

public protocol ListQueries {
    func fetchLists() -> [List]
    func fetchList(by id: Id<List>) -> List?
}
