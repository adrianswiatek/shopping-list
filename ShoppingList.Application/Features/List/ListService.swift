import ShoppingList_Domain

public final class ListService: ListQueries, ListUseCases {
    private let listRepository: ListRepository
    private let itemRepository: ItemRepository
    private let listNameGenerator: ListNameGenerator

    public init(
        listRepository: ListRepository,
        itemRepository: ItemRepository,
        listNameGenerator: ListNameGenerator
    ) {
        self.listRepository = listRepository
        self.itemRepository = itemRepository
        self.listNameGenerator = listNameGenerator
    }

    public func fetchLists() -> [List] {
        listRepository.getLists().sorted { $0.updateDate > $1.updateDate }
    }

    public func fetchList(by id: UUID) -> List? {
        listRepository.getList(by: id)
    }

    public func addList(with name: String) {
        listRepository.add(.withName(provideListName(basedOn: name)))
    }

    public func updateList(with id: UUID, newName name: String) {
        guard let list = fetchList(by: id), list.name != name else { return }
        listRepository.update(list.withChangedName(provideListName(basedOn: name)))
    }

    public func removeList(with id: UUID) {
        listRepository.remove(by: id)
    }

    public func clearList(with id: UUID) {
        guard let list = fetchList(by: id) else { return }

        let items = itemRepository.getItemsWith(state: .toBuy, in: list)
        itemRepository.remove(items)
    }

    public func clearBasketOfList(with id: UUID) {
        guard let list = fetchList(by: id) else { return }

        let items = itemRepository.getItemsWith(state: .inBasket, in: list)
        itemRepository.remove(items)
    }

    private func provideListName(basedOn name: String) -> String {
        name.isEmpty ? listNameGenerator.generate(from: fetchLists()) : name
    }
}
