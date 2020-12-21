import ShoppingList_Domain

public final class ListsService: ListQueries {
    private let listRepository: ListRepository

    public init(listRepository: ListRepository) {
        self.listRepository = listRepository
    }

    public func fetchLists() -> [List] {
        listRepository.getLists().sorted { $0.updateDate > $1.updateDate }
    }

    public func fetchList(by id: UUID) -> List? {
        listRepository.getList(by: id)
    }
}
