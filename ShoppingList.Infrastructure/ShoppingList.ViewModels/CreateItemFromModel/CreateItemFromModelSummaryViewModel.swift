import Combine

public final class CreateItemFromModelSummaryViewModel: ObservableObject {
    @Published
    public var skipSummaryScreen: Bool

    public let selectedItem: ItemToSearchViewModel?
    public let selectedCategory: ItemsCategoryViewModel?

    private let parentViewModel: CreateItemFromModelViewModel

    public init(_ parentViewModel: CreateItemFromModelViewModel) {
        self.parentViewModel = parentViewModel
        self.selectedItem = parentViewModel.searchModelItemViewModel.selectedItem
        self.selectedCategory = parentViewModel.selectItemsCategoryViewModel.selectedCategory
        self.skipSummaryScreen = false
    }

    public func switchItem() {
        parentViewModel.searchModelItemViewModel.selectedItem = nil
    }

    public func switchCategory() {
        parentViewModel.selectItemsCategoryViewModel.selectedCategory = nil
    }

    public func confirmSelection() {
        if skipSummaryScreen {
            parentViewModel.skipSummaryScreen()
        }
        parentViewModel.saveItem(item: selectedItem, category: selectedCategory)
    }
}
