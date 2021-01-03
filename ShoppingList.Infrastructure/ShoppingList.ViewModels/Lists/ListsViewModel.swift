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

    public func restoreList() {
        guard commandBus.canUndo(.lists) else {
            return
        }

        commandBus.undo(.lists)
        fetchLists()
    }

    public func listViewModel(at index: Int) -> ListViewModel {
        .init(listsSubject.value[index], dateFormatter)
    }

    public func fetchLists() {
        listsSubject.send(listQueries.fetchLists())
    }

    public func fetchList(by uuid: UUID) -> List? {
        listQueries.fetchList(by: .fromUuid(uuid))
    }

    public func addList(with name: String) {
        commandBus.execute(AddListCommand(name))
        fetchLists()
    }

    public func updateList(with uuid: UUID, name: String) {
        let existingName = listsSubject.value.first { $0.id.toUuid() == uuid }.map { $0.name }
        guard existingName != name else { return }

        commandBus.execute(UpdateListCommand(.fromUuid(uuid), name))
        fetchLists()
    }

    public func removeList(with uuid: UUID) {
        let command = listsSubject.value
            .first { $0.id.toUuid() == uuid }
            .map { RemoveListCommand($0) }

        guard let removeListCommand = command else { return }
        commandBus.execute(removeListCommand)

        fetchLists()
    }

    public func clearList(with uuid: UUID) {
        commandBus.execute(ClearListCommand(.fromUuid(uuid)))
    }

    public func clearBasketOfList(with uuid: UUID) {
        commandBus.execute(ClearBasketOfListCommand(.fromUuid(uuid)))
    }

    public func isListEmpty(with uuid: UUID) -> Bool {
        listsSubject.value.first { $0.id.toUuid() == uuid }?.containsItemsToBuy == false
    }

    private func mapListsToViewModels(_ lists: [List]) -> [ListViewModel] {
        lists.map { .init($0, dateFormatter) }
    }
}
