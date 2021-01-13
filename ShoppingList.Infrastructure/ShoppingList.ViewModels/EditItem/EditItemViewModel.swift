import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_Shared
import Combine

public final class EditItemViewModel: ViewModel {
    public var state: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    public var dismiss: AnyPublisher<Void, Never> {
        eventBus.events
            .filter { $0 is ItemAddedEvent || $0 is ItemUpdatedEvent }
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public var selectedCategory: AnyPublisher<ItemsCategoryViewModel, Never> {
        selectedCategorySubject.eraseToAnyPublisher()
    }

    public var categories: AnyPublisher<[ItemsCategoryViewModel], Never> {
        categoriesSubject.eraseToAnyPublisher()
    }

    public var selectedList: AnyPublisher<ListViewModel, Never> {
        selectedListSubject.eraseToAnyPublisher()
    }

    public var lists: AnyPublisher<[ListViewModel], Never> {
        listsSubject.eraseToAnyPublisher()
    }

    private let stateSubject: CurrentValueSubject<State, Never>
    private let selectedListSubject: CurrentValueSubject<ListViewModel, Never>
    private let listsSubject: CurrentValueSubject<[ListViewModel], Never>
    private let selectedCategorySubject: CurrentValueSubject<ItemsCategoryViewModel, Never>
    private let categoriesSubject: CurrentValueSubject<[ItemsCategoryViewModel], Never>

    private var cancellables: Set<AnyCancellable>

    private let listQueries: ListQueries
    private let categoryQueries: ItemsCategoryQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus
    private let dateFormatter: DateFormatter

    public init(
        listQueries: ListQueries,
        categoryQueries: ItemsCategoryQueries,
        commandBus: CommandBus,
        eventBus: EventBus
    ) {
        self.listQueries = listQueries
        self.categoryQueries = categoryQueries
        self.commandBus = commandBus
        self.eventBus = eventBus
        self.dateFormatter = configure(.init()) { $0.dateStyle = .medium }

        self.stateSubject = .init(.create)
        self.selectedListSubject = .init(.init(.withName(""), dateFormatter))
        self.listsSubject = .init([])
        self.selectedCategorySubject = .init(.init(.default))
        self.categoriesSubject = .init([])

        self.cancellables = []

        self.bind()
    }

    public func fetchData() {
        fetchLists()
        fetchCategories()
    }

    public func setItem(_ item: ItemViewModel) {
        stateSubject.send(.edit(item: item))
    }

    public func saveItem(name: String, info: String) {
        let categoryUuid = selectedCategorySubject.value.uuid
        let listUuid = selectedListSubject.value.uuid

        let command: Command
        if case .edit(let item) = stateSubject.value {
            command = UpdateItemCommand(item.id, name, info, categoryUuid, listUuid)
        } else {
            command = AddItemCommand(name, info, categoryUuid, listUuid)
        }

        commandBus.execute(command)
    }

    public func addCategory(with name: String) {
        commandBus.execute(AddItemsCategoryCommand(name))
    }

    public func selectCategory(with uuid: UUID) {
        categoriesSubject.value
            .first { $0.uuid == uuid }
            .map { selectedCategorySubject.value = $0 }
    }

    public func addList(with name: String) {
        commandBus.execute(AddListCommand(name))
    }

    private func selectList(with name: String) {
        listsSubject.value
            .first { $0.name == name }
            .map { selectedListSubject.value = $0 }
    }

    public func selectList(with uuid: UUID) {
        listsSubject.value
            .first { $0.uuid == uuid }
            .map { selectedListSubject.value = $0 }
    }

    private func fetchCategories() {
        let categories = self.categoryQueries.fetchCategories()
        self.categoriesSubject.send(categories.map { .init($0) })
    }

    private func fetchLists() {
        let lists = self.listQueries.fetchLists()
        self.listsSubject.send(lists.map { .init($0, self.dateFormatter) })
    }

    private func bind() {
        eventBus.events
            .compactMap { $0 as? ListAddedEvent }
            .sink { [weak self] in
                self?.fetchLists()
                self?.selectList(with: $0.id.toUuid())
            }
            .store(in: &cancellables)

        eventBus.events
            .compactMap { $0 as? ItemsCategoryAddedEvent }
            .sink { [weak self] in
                self?.fetchCategories()
                self?.selectCategory(with: $0.id.toUuid())
            }
            .store(in: &cancellables)
    }
}

extension EditItemViewModel {
    public enum State {
        case create
        case edit(item: ItemViewModel)
    }
}
