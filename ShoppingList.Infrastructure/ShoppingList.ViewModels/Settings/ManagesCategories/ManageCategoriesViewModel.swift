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

    private let categoriesSubject: CurrentValueSubject<[ItemsCategory], Never>
    private let onActionSubject: PassthroughSubject<Action, Never>

    public init(categoryQueries: ItemsCategoryQueries, commandBus: CommandBus) {
        self.categoryQueries = categoryQueries

        self.commandBus = commandBus

        self.categoriesSubject = .init([])
        self.onActionSubject = .init()
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
        fetchCategories()
    }

    public func addCategory(with name: String) {
        commandBus.execute(AddItemsCategoryCommand(name))
        fetchCategories()
    }

    public func updateCategory(with uuid: UUID, name: String) {
        commandBus.execute(UpdateItemsCategoryCommand(.fromUuid(uuid), name))
        fetchCategories()
    }

    public func removeCategory(with uuid: UUID) {
        let numberOfItems = category(with: uuid)?.itemsCount ?? 0

        numberOfItems == 0
            ? removeCategoryWithItems(with: uuid)
            : onActionSubject.send(.showRemoveCategoryPopup(uuid))
    }

    public func removeCategoryWithItems(with uuid: UUID) {
        let command = category(with: uuid).map {
            RemoveItemsCategoryCommand($0)
        }

        guard let removeItemsCategoryCommand = command else { return }
        commandBus.execute(removeItemsCategoryCommand)

        fetchCategories()
    }

    public func hasCategory(with name: String) -> Bool {
        categoriesSubject.value.allSatisfy { $0.name != name }
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
