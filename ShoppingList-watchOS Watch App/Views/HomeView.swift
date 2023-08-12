import SwiftUI

struct HomeView: View {
    private let viewModelsFactory: ViewModelsFactory

    @State
    private var selectedTab: HomeTab

    init(_ viewModelsFactory: ViewModelsFactory) {
        self.viewModelsFactory = viewModelsFactory
        self.selectedTab = .lists
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ShoppingListsView(viewModelsFactory.shoppingLists())
                    .navigationDestination(for: ShoppingListViewModel.self) { list in
                        ShoppingItemsView(viewModelsFactory.shopingItems(list))
                    }
            }
            .tag(HomeTab.lists)

            SettingsView(viewModelsFactory.settings())
                .tag(HomeTab.settings)
        }
        .tabViewStyle(.carousel)
    }
}

private extension HomeView {
    enum HomeTab {
        case lists
        case settings
    }
}
