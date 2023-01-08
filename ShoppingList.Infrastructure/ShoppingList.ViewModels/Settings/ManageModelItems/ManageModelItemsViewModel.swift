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

    private let modelItemQueries: ModelItemQueries
    private let itemsCategoryQueries: ItemsCategoryQueries
    private let commandBus: CommandBus
    private let eventBus: EventBus

    private let modelItemsSubject: CurrentValueSubject<[ModelItem], Never>
    private let onActionSubject: PassthroughSubject<Action, Never>

    private var cancellables: Set<AnyCancellable>

    public init(
        modelItemQueries: ModelItemQueries,
        itemsCategoryQueries: ItemsCategoryQueries,
        commandBus: CommandBus,
        eventBus: EventBus
    ) {
        self.modelItemQueries = modelItemQueries
        self.itemsCategoryQueries = itemsCategoryQueries
        self.eventBus = eventBus
        self.commandBus = commandBus

        self.modelItemsSubject = .init([])
        self.onActionSubject = .init()

        self.cancellables = []

        self.bind()
    }

    public func fetchModelItems() {
        modelItemsSubject.send(
            modelItemQueries.fetchModelItems(.inAlphabeticalOrder())
        )
    }

    public func removeModelItem(withUuid uuid: UUID) {
        let hasUuid: (ModelItem) -> Bool = { $0.id.toUuid() == uuid }
        guard let modelItem = modelItemsSubject.value.first(where: hasUuid) else {
            return
        }
        commandBus.execute(RemoveModelItemCommand(modelItem))
    }

    private func bind() {
        eventBus.events
            .filterType(
                ModelItemRemovedEvent.self,
                ModelItemUpdatedEvent.self
            )
            .sink { [weak self] _ in self?.fetchModelItems() }
            .store(in: &cancellables)
    }

    private func mapModelItemsToViewModels(_ modelItems: [ModelItem]) -> [ModelItemViewModel] {
        let categories = itemsCategoryQueries.fetchCategories()
        let viewModelFrom = ModelItemViewModel.Factory.fromModelItem
        return modelItems.compactMap { viewModelFrom($0, categories) }
    }
}

public extension ManageModelItemsViewModel {
    enum Action {
        case doNothing
    }
}
