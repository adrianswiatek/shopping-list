import Foundation

struct ShoppingListViewModel: Hashable, Identifiable {
    let id: String
    let name: String
    let visited: Bool

    static func fromShoppingList(_ list: ShoppingList) -> ShoppingListViewModel {
        ShoppingListViewModel(id: list.id.asString(), name: list.name, visited: list.visited)
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
