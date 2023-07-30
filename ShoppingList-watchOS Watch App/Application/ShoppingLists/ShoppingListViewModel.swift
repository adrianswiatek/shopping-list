import Foundation

struct ShoppingListViewModel: Hashable, Identifiable {
    let id: String
    let name: String

    static func fromShoppingList(_ list: ShoppingList) -> ShoppingListViewModel {
        ShoppingListViewModel(id: list.id.asString(), name: list.name)
    }

    struct NameSorter: SortComparator {
        var order: SortOrder = .forward

        func compare(
            _ lhs: ShoppingListViewModel,
            _ rhs: ShoppingListViewModel
        ) -> ComparisonResult {
            lhs.name.localizedCompare(rhs.name)
        }
    }
}
