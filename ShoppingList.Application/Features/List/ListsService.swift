import ShoppingList_Domain
import Combine

public final class ListsService: ListQueries {
    private let listRepository: ListRepository

    public init(listRepository: ListRepository) {
        self.listRepository = listRepository
    }

    public func fetchLists() -> [List] {
        listRepository.allLists().sorted {
            $0.updateDate > $1.updateDate
        }
    }

    public func fetchList(by id: Id<List>) -> List? {
        listRepository.list(with: id)
    }
}
