import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class ManageCategoriesViewModel: ViewModel {
    public var categoriesPublisher: AnyPublisher<[ItemsCategoryViewModel], Never> {
        categoriesSubject
            .map { [weak self] in self?.mapCategoriesToViewModels($0) ?? [] }
            .eraseToAnyPublisher()
    }

    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.categories)
    }

    private let categoryQueries: ItemsCategoryQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    private let categoriesSubject: CurrentValueSubject<[ItemsCategory], Never>
    private let onActionSubject: PassthroughSubject<Action, Never>

    private var cancellables: Set<AnyCancellable>

    public init(categoryQueries: ItemsCategoryQueries, commandBus: CommandBus, eventBus: EventBus) {
        self.categoryQueries = categoryQueries
        self.eventBus = eventBus
        self.commandBus = commandBus

        self.categoriesSubject = .init([])
        self.onActionSubject = .init()

        self.cancellables = []

        self.bind()
    }

    public func fetchCategories() {
        categoriesSubject.send(categoryQueries.fetchCategories())
    }

    public func cleanUp() {
        commandBus.remove(.categories)
    }

    public func restoreCategory() {
        guard commandBus.canUndo(.categories) else {
            return
        }
        commandBus.undo(.categories)
    }

    public func addCategory(with name: String) {
        commandBus.execute(AddItemsCategoryCommand(name))
    }

    public func updateCategory(with uuid: UUID, name: String) {
        commandBus.execute(UpdateItemsCategoryCommand(.fromUuid(uuid), name))
    }

    public func removeCategory(with uuid: UUID) {
        let numberOfItems = category(with: uuid)?.itemsCount ?? 0

        numberOfItems == 0
            ? removeCategoryWithItems(with: uuid)
            : onActionSubject.send(.showRemoveCategoryPopup(uuid))
    }

    public func removeCategoryWithItems(with uuid: UUID) {
        guard let selectedCategory = category(with: uuid) else { return }
        commandBus.execute(RemoveItemsCategoryCommand(selectedCategory))
    }

    public func hasCategory(with name: String) -> Bool {
        categoriesSubject.value.allSatisfy { $0.name != name }
    }

    private func bind() {
        eventBus.events
            .filterType(
                ItemsCategoryAddedEvent.self,
                ItemsCategoryUpdatedEvent.self,
                ItemsCategoryRemovedEvent.self
            )
            .sink { [weak self] _ in self?.fetchCategories() }
            .store(in: &cancellables)
    }

    private func category(with uuid: UUID) -> ItemsCategory? {
        categoriesSubject.value.first { $0.id.toUuid() == uuid }
    }

    private func mapCategoriesToViewModels(
        _ itemsCategories: [ItemsCategory]
    ) -> [ItemsCategoryViewModel] {
        itemsCategories.map { .init($0) }
    }
}

public extension ManageCategoriesViewModel {
    enum Action {
        case showRemoveCategoryPopup(_ uuid: UUID)
    }
}
