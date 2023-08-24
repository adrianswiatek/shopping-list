import Combine

public final class CreateItemFromModelSummaryViewModel: ObservableObject {
    public let selectedItem: ItemToSearchViewModel?
    public let selectedCategory: ItemsCategoryViewModel?

    private let parentViewModel: CreateItemFromModelViewModel

    public init(_ parentViewModel: CreateItemFromModelViewModel) {
        self.parentViewModel = parentViewModel
        self.selectedItem = parentViewModel.selectedItem
        self.selectedCategory = parentViewModel.selectedCategory
    }

    public func switchItem() {
        parentViewModel.selectedItem = nil
    }

    public func switchCategory() {
        parentViewModel.selectedCategory = nil
    }

    public func confirmSelection() {

    }
}
