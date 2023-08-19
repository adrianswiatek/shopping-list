import Foundation

struct ShoppingItemViewModel: Identifiable {
    let id: String
    let name: String
    let category: String
    let inBasket: Bool
    let lastChange: Date

    static func fromShoppingItem(_ item: ShoppingItem) -> ShoppingItemViewModel {
        ShoppingItemViewModel(
            id: item.id.asString(),
            name: item.name,
            category: item.category,
            inBasket: item.state == .inBasket,
            lastChange: item.lastChange
        )
    }
}
