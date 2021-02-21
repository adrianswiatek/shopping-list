import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_Shared
import Combine

public final class ListsViewModel: ViewModel {
    public var listsPublisher: AnyPublisher<[ListViewModel], Never> {
        listsSubject
            .map { [weak self] in
                self?.mapListsToViewModels($0) ?? []
            }
            .eraseToAnyPublisher()
    }

    public var messagePublisher: AnyPublisher<String, Never> {
        messageSubject.eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.lists)
    }

    public var hasLists: Bool {
        !listsSubject.value.isEmpty
    }

    private let listsSubject: CurrentValueSubject<[List], Never>
    private let messageSubject: PassthroughSubject<String, Never>
    private var cancellables: Set<AnyCancellable>

    private let listQueries: ListQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus
    private let dateFormatter: DateFormatter

    public init(listQueries: ListQueries, commandBus: CommandBus, eventBus: EventBus) {
        self.listQueries = listQueries
        self.commandBus = commandBus
        self.eventBus = eventBus
        self.dateFormatter = configure(.init()) { $0.dateStyle = .medium }

        self.listsSubject = .init([])
        self.messageSubject = .init()
        self.cancellables = []

        self.bind()
    }

    public func cleanUp() {
        commandBus.remove(.lists)
    }

    public func restoreList() {
        guard commandBus.canUndo(.lists) else {
            return
        }

        commandBus.undo(.lists)
    }

    public func listViewModel(at index: Int) -> ListViewModel {
        .init(listsSubject.value[index], dateFormatter)
    }

    public func fetchLists() {
        listQueries.fetchLists()
            .sink { [weak self] in self?.listsSubject.send($0) }
            .store(in: &cancellables)
    }

    public func fetchList(by uuid: UUID) -> List? {
        listQueries.fetchList(by: .fromUuid(uuid))
    }

    public func addList(with name: String) {
        commandBus.execute(AddListCommand(name))
    }

    public func updateList(with uuid: UUID, name: String) {
        let existingName = listsSubject.value.first { $0.id.toUuid() == uuid }.map { $0.name }
        guard existingName != name else { return }

        commandBus.execute(UpdateListCommand(.fromUuid(uuid), name))
    }

    public func removeList(with uuid: UUID) {
        let command = listsSubject.value
            .first { $0.id.toUuid() == uuid }
            .map { RemoveListCommand($0) }

        guard let removeListCommand = command else { return }
        commandBus.execute(removeListCommand)
    }

    public func clearList(with uuid: UUID) {
        commandBus.execute(ClearListCommand(.fromUuid(uuid)))
    }

    public func clearBasketOfList(with uuid: UUID) {
        commandBus.execute(ClearBasketOfListCommand(.fromUuid(uuid)))
    }

    public func isEmptyList(with uuid: UUID) -> Bool {
        listsSubject.value.first { $0.id.toUuid() == uuid }?.containsItemsToBuy == false
    }

    public func isBasketEmptyInList(with uuid: UUID) -> Bool {
        listsSubject.value.first { $0.id.toUuid() == uuid }?.containsItemsInBasket == false
    }

    private func bind() {
        eventBus.events
            .filterType(
                ListAddedEvent.self,
                ListRemovedEvent.self,
                ListUpdatedEvent.self
            )
            .sink { [weak self] _ in self?.fetchLists() }
            .store(in: &cancellables)

        eventBus.events
            .compactMap { $0 as? ListNotAddedEvent }
            .sink { [weak self] in
                if case .alreadyExists = $0.reason {
                    self?.messageSubject.send("List with given name already exists.")
                }
            }
            .store(in: &cancellables)
    }

    private func mapListsToViewModels(_ lists: [List]) -> [ListViewModel] {
        lists.map { .init($0, dateFormatter) }
    }
}
