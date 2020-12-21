import ShoppingList_Application
import ShoppingList_Domain
import Combine

public final class ManageCategoriesViewModel: ViewModel {
    public var categoriesPublisher: AnyPublisher<[ItemsCategoryViewModel], Never> {
        categoriesSubject
            .map { [weak self] in self?.mapCategoriesToViewModels($0) ?? [] }
            .eraseToAnyPublisher()
    }

    public var isRestoreButtonEnabled: Bool {
        commandBus.canUndo(.categories)
    }

    private let categoryQueries: ItemsCategoryQueries
    private let itemRepository: ItemRepository
    private let commandBus: CommandBus

    private let categoriesSubject: CurrentValueSubject<[ItemsCategory], Never>

    public init(
        categoryQueries: ItemsCategoryQueries,
        itemRepository: ItemRepository,
        commandBus: CommandBus
    ) {
        self.categoryQueries = categoryQueries
        self.itemRepository = itemRepository
        self.commandBus = commandBus
        self.categoriesSubject = .init([])
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

    public func removeCategory(with id: UUID) {
        let command = categoriesSubject.value
            .first { $0.id == id }
            .map { RemoveItemsCategoryCommand($0) }

        guard let removeItemsCategoryCommand = command else { return }
        commandBus.execute(removeItemsCategoryCommand)

        fetchCategories()
    }

    public func hasCategory(with name: String) -> Bool {
        categoriesSubject.value.allSatisfy { $0.name != name }
    }

    private func mapCategoriesToViewModels(
        _ itemsCategories: [ItemsCategory]
    ) -> [ItemsCategoryViewModel] {
        itemsCategories.map { .init($0) }
    }
}
