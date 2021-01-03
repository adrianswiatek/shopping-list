import ShoppingList_Domain

public protocol ListQueries {
    func fetchList(by id: Id<List>) -> List?
    func fetchLists() -> [List]
}
