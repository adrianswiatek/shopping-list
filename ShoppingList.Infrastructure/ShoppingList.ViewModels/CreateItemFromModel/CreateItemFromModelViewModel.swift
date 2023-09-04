import ShoppingList_Application
import ShoppingList_Domain

import Combine
import SwiftUI

public final class CreateItemFromModelViewModel: ObservableObject, ViewModel {
    @Published
    public var viewMode: ViewMode

    public var summaryViewModel: CreateItemFromModelSummaryViewModel {
        CreateItemFromModelSummaryViewModel(self)
    }

    public let searchModelItemViewModel: SearchModelItemViewModel
    public let selectItemsCategoryViewModel: SelectItemsCategoryViewModel

    private var list: ListViewModel!
    private var dismiss: () -> Void

    private let localPreferences: LocalPreferences
    private let commandBus: CommandBus

    private var cancellables: Set<AnyCancellable>

    public init(
        modelItemQueries: ModelItemQueries,
        itemsCategoryQueries: ItemsCategoryQueries,
        localPreferences: LocalPreferences,
        commandBus: CommandBus
    ) {
        self.localPreferences = localPreferences
        self.commandBus = commandBus

        self.searchModelItemViewModel = .init(modelItemQueries)
        self.selectItemsCategoryViewModel = .init(itemsCategoryQueries)

        self.dismiss = { }
        self.viewMode = .searchItem
        self.cancellables = []

        self.bind()
    }

    public func setList(_ list: ListViewModel) {
        self.list = list
    }

    public func setDismiss(_ dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }

    public func saveItem(item: ItemToSearchViewModel?, category: ItemsCategoryViewModel?) {
        let itemName: String? = item?.name
        let categoryId: Id<ItemsCategory>? = category.map { .fromUuid($0.uuid) }

        guard let itemName, let categoryId else {
            return
        }

        commandBus.execute(
            AddItemCommand(itemName, categoryId, .fromUuid(list.uuid))
        )
    }

    public func skipSummaryScreen() {
        localPreferences.shouldSkipSearchSummaryView = true
    }

    private func bind() {
        Publishers
            .CombineLatest(
                searchModelItemViewModel.$selectedItem,
                selectItemsCategoryViewModel.$selectedCategory
            )
            .sink { [weak self] item, category in
                switch (item, category) {
                case (nil, _):
                    self?.viewMode = .searchItem
                case (_, nil):
                    self?.viewMode = .selectCategory
                case (_, _) where self?.localPreferences.shouldSkipSearchSummaryView == true:
                    self?.saveItem(item: item, category: category)
                    self?.dismiss()
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
