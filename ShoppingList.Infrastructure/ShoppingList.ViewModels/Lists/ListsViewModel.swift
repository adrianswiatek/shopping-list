import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_Shared
import Combine

public final class ListsViewModel: ViewModel {
    public var listsPublisher: AnyPublisher<[ListViewModel], Never> {
        listsSubject.map { [weak self] in self?.mapListsToViewModels($0) ?? [] }.eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.lists)
    }

    public var hasLists: Bool {
        !listsSubject.value.isEmpty
    }

    private let commandBus: CommandBus
    private let listQueries: ListQueries
    private let dateFormatter: DateFormatter

    private let listsSubject: CurrentValueSubject<[List], Never>

    public init(listQueries: ListQueries, commandBus: CommandBus) {
        self.listQueries = listQueries
        self.commandBus = commandBus

        self.listsSubject = .init([])

        self.dateFormatter = configure(.init()) { $0.dateStyle = .medium }
    }

    public func cleanUp() {
        commandBus.remove(.lists)
    }

    public func restore() {
        if commandBus.canUndo(.lists) {
            commandBus.undo(.lists)
            fetchLists()
        }
    }

    public func listViewModel(at index: Int) -> ListViewModel {
        .init(listsSubject.value[index], dateFormatter)
    }

    public func fetchLists() {
        listsSubject.send(listQueries.fetchLists())
    }

    public func fetchList(by id: UUID) -> List? {
        listQueries.fetchList(by: id)
    }

    public func addList(with name: String) {
        commandBus.execute(AddListCommand(name))
        fetchLists()
    }

    public func updateList(with id: UUID, name: String) {
        let existingName = listsSubject.value.first { $0.id == id }.map { $0.name }
        guard existingName != name else { return }

        commandBus.execute(UpdateListCommand(id, name))
        fetchLists()
    }

    public func removeEmptyList(with id: UUID) {
        let command = listsSubject.value
            .first { $0.id == id }
            .map { RemoveListCommand($0) }

        guard let removeListCommand = command else { return }
        commandBus.execute(removeListCommand)

        fetchLists()
    }

    public func clearList(with id: UUID) {
        commandBus.execute(ClearListCommand(id))
    }

    public func clearBasketOfList(with id: UUID) {
        commandBus.execute(ClearBasketOfListCommand(id))
    }

    public func isListEmpty(with id: UUID) -> Bool {
        listsSubject.value.first { $0.id == id }?.containsItemsToBuy == false
    }

    private func mapListsToViewModels(_ list: [List]) -> [ListViewModel] {
        list.map { .init($0, dateFormatter) }
    }
}
