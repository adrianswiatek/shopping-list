import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class ManageModelItemsViewModel: ViewModel {
    public var modelItemsPublisher: AnyPublisher<[ModelItemViewModel], Never> {
        modelItemsSubject
            .map { [weak self] in self?.mapModelItemsToViewModels($0) ?? [] }
            .eraseToAnyPublisher()
    }

    public var onAction: AnyPublisher<Action, Never> {
        onActionSubject.eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.categories)
    }

    private let modelItemQueries: ItemsCategoryQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    private let modelItemsSubject: CurrentValueSubject<[ModelItem], Never>
    private let onActionSubject: PassthroughSubject<Action, Never>

    private var cancellables: Set<AnyCancellable>

    public init(
        modelItemQueries: ItemsCategoryQueries,
        commandBus: CommandBus,
        eventBus: EventBus
    ) {
        self.modelItemQueries = modelItemQueries
        self.eventBus = eventBus
        self.commandBus = commandBus

        self.modelItemsSubject = .init([])
        self.onActionSubject = .init()

        self.cancellables = []

        self.bind()
    }

    public func fetchCategories() {
        modelItemsSubject.send([.newWithName("Truskawski")])
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

    public func addModelItem(withName name: String) {
        commandBus.execute(AddItemsCategoryCommand(name))
    }

    public func updateModelItem(withUuid uuid: UUID, andName name: String) {
//        commandBus.execute(UpdateItemsCategoryCommand(.fromUuid(uuid), name))
    }

    public func removeCategory(withUuid uuid: UUID) {
//        let numberOfItems = category(with: uuid)?.itemsCount ?? 0
//
//        numberOfItems == 0
//            ? removeCategoryWithItems(with: uuid)
//            : onActionSubject.send(.showRemoveCategoryPopup(uuid))
    }

    public func removeCategoryWithItems(withUuid uuid: UUID) {
//        guard let selectedCategory = category(withUuid: uuid) else { return }
//        commandBus.execute(RemoveItemsCategoryCommand(selectedCategory))
    }

    public func hasModelItem(withName name: String) -> Bool {
        false
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

    private func mapModelItemsToViewModels(_ modelItems: [ModelItem]) -> [ModelItemViewModel] {
        let categories = modelItemQueries.fetchCategories()
        return modelItems.compactMap {
            ModelItemViewModel.Factory.fromModelItem($0, categories: categories)
        }
    }
}

public extension ManageModelItemsViewModel {
    enum Action {
        case doNothing
    }
}
