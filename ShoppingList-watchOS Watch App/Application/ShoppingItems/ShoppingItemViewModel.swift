import Foundation

struct ShoppingItemViewModel: Identifiable {
    let id: String
    let name: String
    let category: String
    let inBasket: Bool

    static func fromShoppingItem(_ item: ShoppingItem) -> ShoppingItemViewModel {
        ShoppingItemViewModel(
            id: item.id.asString(),
            name: item.name,
            category: item.category,
            inBasket: item.state == .inBasket
        )
    }

    struct NameSorter: SortComparator {
        var order: SortOrder = .forward

        func compare(
            _ lhs: ShoppingItemViewModel,
            _ rhs: ShoppingItemViewModel
        ) -> ComparisonResult {
            lhs.name.localizedCompare(rhs.name)
        }
    }
}
