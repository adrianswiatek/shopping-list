import ShoppingList_Application
import ShoppingList_Domain

import Combine
import SwiftUI

public final class CreateItemFromModelViewModel: ObservableObject, ViewModel {
    @Published
    public var selectedItem: ItemToSearchViewModel?

    @Published
    public var selectedCategory: ItemsCategoryViewModel?

    @Published
    public var viewMode: ViewMode

    public var summaryViewModel: CreateItemFromModelSummaryViewModel {
        .init(self)
    }

    public let searchModelItemViewModel: SearchModelItemViewModel
    public let selectItemsCategoryViewModel: SelectItemsCategoryViewModel

    private var list: ListViewModel!

    private let commandBus: CommandBus
    private var cancellables: Set<AnyCancellable>

    public init(
        modelItemQueries: ModelItemQueries,
        itemsCategoryQueries: ItemsCategoryQueries,
        commandBus: CommandBus
    ) {
        self.commandBus = commandBus

        self.searchModelItemViewModel = .init(modelItemQueries)
        self.selectItemsCategoryViewModel = .init(itemsCategoryQueries)

        self.viewMode = .searchItem
        self.cancellables = []

        self.bind()
    }

    public func setList(_ list: ListViewModel) {
        self.list = list
    }

    public func saveItemFromSelection() {
        let itemName: String? = selectedItem?.name
        let categoryId: Id<ItemsCategory>? = selectedCategory.map { .fromUuid($0.uuid) }

        guard let itemName, let categoryId else {
            return
        }

        commandBus.execute(
            AddItemCommand(itemName, categoryId, .fromUuid(list.uuid))
        )
    }

    private func bind() {
        searchModelItemViewModel
            .$selectedItem
            .sink { [weak self] in self?.selectedItem = $0 }
            .store(in: &cancellables)

        selectItemsCategoryViewModel
            .$selectedCategory
            .sink { [weak self] in self?.selectedCategory = $0 }
            .store(in: &cancellables)

        Publishers
            .CombineLatest($selectedItem, $selectedCategory)
            .sink { [weak self] item, category in
                switch (item, category) {
                case (nil, _):
                    self?.viewMode = .searchItem
                case (_, nil):
                    self?.viewMode = .selectCategory
                default:
                    self?.viewMode = .summary
                }
            }
            .store(in: &cancellables)
    }
}

extension CreateItemFromModelViewModel {
    public enum ViewMode {
        case searchItem
        case selectCategory
        case summary
    }
}
