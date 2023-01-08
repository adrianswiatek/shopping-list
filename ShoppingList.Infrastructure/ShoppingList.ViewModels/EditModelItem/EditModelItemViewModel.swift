import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class EditModelItemViewModel: ViewModel {
    public var dismiss: AnyPublisher<Void, Never> {
        eventBus.events
            .filterType(ModelItemUpdatedEvent.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public var modelItem: AnyPublisher<ModelItemViewModel, Never> {
        modelItemSubject.eraseToAnyPublisher()
    }

    public var selectedCategory: AnyPublisher<ItemsCategoryViewModel, Never> {
        selectedCategorySubject.eraseToAnyPublisher()
    }

    public var categories: AnyPublisher<[ItemsCategoryViewModel], Never> {
        categoriesSubject.eraseToAnyPublisher()
    }

    private let modelItemSubject: CurrentValueSubject<ModelItemViewModel, Never>
    private let selectedCategorySubject: CurrentValueSubject<ItemsCategoryViewModel, Never>
    private let categoriesSubject: CurrentValueSubject<[ItemsCategoryViewModel], Never>

    private var cancellables: Set<AnyCancellable>

    private let categoryQueries: ItemsCategoryQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    public init(
        categoryQueries: ItemsCategoryQueries,
        commandBus: CommandBus,
        eventBus: EventBus
    ) {
        self.categoryQueries = categoryQueries
        self.commandBus = commandBus
        self.eventBus = eventBus

        self.modelItemSubject = .init(.empty)
        self.selectedCategorySubject = .init(.empty)
        self.categoriesSubject = .init([])

        self.cancellables = []

        self.bind()
    }

    public func setModelItem(_ modelItem: ModelItemViewModel) {
        self.modelItemSubject.send(modelItem)
    }

    public func saveModelItem(name: String) {
        let categoryId: Id<ItemsCategory> = .fromUuid(selectedCategorySubject.value.uuid)
        let modelItemId: Id<ModelItem> = .fromUuid(modelItemSubject.value.uuid)
        commandBus.execute(UpdateModelItemCommand(modelItemId, name, categoryId))
    }

    public func fetchCategories() {
        let categories = categoryQueries.fetchCategories()
        categoriesSubject.send(categories.map { .init($0) })
    }

    public func addCategoryWithName(_ name: String) {
        commandBus.execute(AddItemsCategoryCommand(name))
    }

    public func selectCategoryWithUuid(_ uuid: UUID) {
        categoriesSubject.value
            .first { $0.uuid == uuid }
            .map { selectedCategorySubject.value = $0 }
    }

    private func bind() {
        eventBus.events
            .compactMap { $0 as? ItemsCategoryAddedEvent }
            .sink { [weak self] in
                self?.fetchCategories()
                self?.selectCategory(with: $0.category.id.toUuid())
            }
            .store(in: &cancellables)

        modelItem
            .combineLatest(categories)
            .compactMap { item, categories in categories.first { $0.name == item.categoryName } }
            .sink { [weak self] category in self?.selectedCategorySubject.send(category) }
            .store(in: &cancellables)
    }

    private func selectCategory(with uuid: UUID) {
        categoriesSubject.value
            .first { $0.uuid == uuid }
            .map { selectedCategorySubject.value = $0 }
    }
}
