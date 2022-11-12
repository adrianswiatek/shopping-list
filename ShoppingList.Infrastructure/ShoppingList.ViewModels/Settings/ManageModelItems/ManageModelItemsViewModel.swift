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

    private func bind() {
        eventBus.events
            .filterType(
                // Actions to be filtered
            )
            .sink { [weak self] _ in self?.fetchModelItems() }
            .store(in: &cancellables)
    }

    private func mapModelItemsToViewModels(_ modelItems: [ModelItem]) -> [ModelItemViewModel] {
        let categories = itemsCategoryQueries.fetchCategories()
        let viewModelFrom = ModelItemViewModel.Factory.fromModelItem
        let result = modelItems.compactMap { viewModelFrom($0, categories) }
        return result
    }
}

public extension ManageModelItemsViewModel {
    enum Action {
        case doNothing
    }
}
