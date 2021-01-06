import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class EditItemViewModel: ViewModel {
    public var state: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    public var selectedCategory: AnyPublisher<ItemsCategoryViewModel, Never> {
        selectedCategorySubject.map { .init($0) }.eraseToAnyPublisher()
    }

    public var categories: AnyPublisher<[ItemsCategoryViewModel], Never> {
        categoriesSubject.map { $0.compactMap { .init($0) } }.eraseToAnyPublisher()
    }

    private var currentList: ListViewModel!

    private var stateSubject: CurrentValueSubject<State, Never>
    private let selectedCategorySubject: CurrentValueSubject<ItemsCategory, Never>
    private let categoriesSubject: CurrentValueSubject<[ItemsCategory], Never>

    private let categoryQueries: ItemsCategoryQueries
    private let commandBus: CommandBus

    public init(categoryQueries: ItemsCategoryQueries, commandBus: CommandBus) {
        self.categoryQueries = categoryQueries
        self.commandBus = commandBus

        self.stateSubject = .init(.create)
        self.selectedCategorySubject = .init(.default)
        self.categoriesSubject = .init([])
    }

    public func fetchData() {
        categoriesSubject.send(categoryQueries.fetchCategories())
    }

    public func setList(_ list: ListViewModel) {
        currentList = list
    }

    public func setItem(_ item: ItemViewModel) {
        stateSubject.send(.edit(item: item))
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
}

extension EditItemViewModel {
    public enum State {
        case create
        case edit(item: ItemViewModel)
    }
}
