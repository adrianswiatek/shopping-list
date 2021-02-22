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
            .filter { $0 is ItemsAddedEvent || $0 is ItemUpdatedEvent }
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

    public func setList(_ list: ListViewModel) {
        listsSubject.value += [list]
        selectedListSubject.value = list
    }

    public func setItem(_ item: ItemToBuyViewModel) {
        stateSubject.send(.edit(item: item))
    }

    public func saveItem(name: String, info: String) {
        let categoryId: Id<ItemsCategory> = .fromUuid(selectedCategorySubject.value.uuid)
        let listId: Id<List> = .fromUuid(selectedListSubject.value.uuid)

        if case .edit(let item) = stateSubject.value {
            let itemId: Id<Item> = .fromUuid(item.uuid)
            commandBus.execute(UpdateItemCommand(itemId, name, info, categoryId, listId))
        } else {
            commandBus.execute(AddItemCommand(name, info, categoryId, listId))
        }
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

    public func selectList(with uuid: UUID) {
        listsSubject.value
            .first { $0.uuid == uuid }
            .map { selectedListSubject.value = $0 }
    }

    private func fetchCategories() {
        let categories = categoryQueries.fetchCategories()
        categoriesSubject.send(categories.map { .init($0) })
    }

    private func fetchLists() {
        let lists = listQueries.fetchLists()
        listsSubject.send(lists.map { .init($0, self.dateFormatter) })
    }

    private func bind() {
        eventBus.events
            .compactMap { $0 as? ListAddedEvent }
            .sink { [weak self] in
                self?.fetchLists()
                self?.selectList(with: $0.list.id.toUuid())
            }
            .store(in: &cancellables)

        eventBus.events
            .compactMap { $0 as? ItemsCategoryAddedEvent }
            .sink { [weak self] in
                self?.fetchCategories()
                self?.selectCategory(with: $0.category.id.toUuid())
            }
            .store(in: &cancellables)

        state
            .compactMap { $0.item }
            .removeDuplicates()
            .combineLatest(categories)
            .compactMap { item, categories in categories.first { $0.name == item.categoryName } }
            .sink { [weak self] category in self?.selectedCategorySubject.send(category) }
            .store(in: &cancellables)
    }
}

extension EditItemViewModel {
    public enum State {
        case create
        case edit(item: ItemToBuyViewModel)

        public var item: ItemToBuyViewModel? {
            switch self {
            case .create: return nil
            case .edit(let item): return item
            }
        }
    }
}
