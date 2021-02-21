import ShoppingList_Domain
import Combine

public final class ListsService: ListQueries {
    private let listRepository: ListRepository

    public init(listRepository: ListRepository) {
        self.listRepository = listRepository
    }

    public func fetchLists() -> Future<[List], Never> {
        Future { [weak self] promise in
            guard let self = self else { return }

            DispatchQueue.global().async {
                let lists = self.listRepository.allLists().sorted {
                    $0.updateDate > $1.updateDate
                }

                DispatchQueue.main.async {
                    promise(.success(lists))
                }
            }
        }
    }

    public func fetchList(by id: Id<List>) -> List? {
        listRepository.list(with: id)
    }
}
