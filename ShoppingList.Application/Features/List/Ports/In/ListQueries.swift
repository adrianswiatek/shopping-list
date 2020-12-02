import ShoppingList_Domain

public protocol ListQueries {
    func fetchList(by id: UUID) -> List?
    func fetchLists() -> [List]
}
