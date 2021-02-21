import ShoppingList_Domain
import Combine

public protocol ListQueries {
    func fetchLists() -> Future<[List], Never>
    func fetchList(by id: Id<List>) -> List?
}
