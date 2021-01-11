import ShoppingList_Application
import ShoppingList_Domain
import ShoppingList_Shared
import Combine

public final class EditItemViewModel: ViewModel {
    public var state: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
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

    private var stateSubject: CurrentValueSubject<State, Never>
    private var selectedListSubject: CurrentValueSubject<ListViewModel, Never>
    private let listsSubject: CurrentValueSubject<[ListViewModel], Never>
    private let selectedCategorySubject: CurrentValueSubject<ItemsCategoryViewModel, Never>
    private let categoriesSubject: CurrentValueSubject<[ItemsCategoryViewModel], Never>

    private let listQueries: ListQueries
    private let categoryQueries: ItemsCategoryQueries
    private let commandBus: CommandBus
    private let dateFormatter: DateFormatter

    public init(
        listQueries: ListQueries,
        categoryQueries: ItemsCategoryQueries,
        commandBus: CommandBus
    ) {
        self.listQueries = listQueries
        self.categoryQueries = categoryQueries
        self.commandBus = commandBus
        self.dateFormatter = configure(.init()) { $0.dateStyle = .medium }

        self.stateSubject = .init(.create)
        self.selectedListSubject = .init(.init(.withName(""), dateFormatter))
        self.listsSubject = .init([])
        self.selectedCategorySubject = .init(.init(.default))
        self.categoriesSubject = .init([])
    }

    public func fetchData() {
        categoriesSubject.send(
            categoryQueries.fetchCategories().map { .init($0) }
        )

        listsSubject.send(
            listQueries.fetchLists().map { .init($0, dateFormatter) }
        )
    }

    public func setItem(_ item: ItemViewModel) {
        stateSubject.send(.edit(item: item))
    }

    public func saveItem(name: String, info: String) {
        let categoryUuid = selectedCategorySubject.value.uuid
        let listUuid = selectedListSubject.value.uuid

        let command: CommandNew
        if case .edit(let item) = stateSubject.value {
            command = UpdateItemCommand(item.id, name, info, categoryUuid, listUuid)
        } else {
            command = AddItemCommand(name, info, categoryUuid, listUuid)
        }

        commandBus.execute(command)
    }

    public func addCategory(with name: String) {
        commandBus.execute(AddItemsCategoryCommand(name))

        fetchData()
        selectCategory(with: name)
    }

    public func selectCategory(with name: String) {
        categoriesSubject.value
            .first { $0.name == name }
            .map { selectedCategorySubject.value = $0 }
    }

    public func addList(with name: String) {
        commandBus.execute(AddListCommand(name))

        fetchData()
        selectList(with: name)
    }

    public func selectList(with name: String) {
        listsSubject.value
            .first { $0.name == name }
            .map { selectedListSubject.value = $0 }
    }
}

extension EditItemViewModel {
    public enum State {
        case create
        case edit(item: ItemViewModel)
    }
}
