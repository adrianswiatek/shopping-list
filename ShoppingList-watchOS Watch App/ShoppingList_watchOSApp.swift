import SwiftUI

@main
struct ShoppingList_watchOS_Watch_AppApp: App {
    private let viewModelsFactory = {
        let container = Container()
        return ViewModelsFactory(container: container)
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ShoppingListsView(viewModelsFactory.shoppingLists())
                    .navigationDestination(for: ShoppingListViewModel.self) { list in
                        ShoppingItemsView(viewModelsFactory.shopingItems(list))
                    }
            }
        }
    }
}
