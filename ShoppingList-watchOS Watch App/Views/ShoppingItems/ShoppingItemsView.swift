import SwiftUI

struct ShoppingItemsView: View {
    @ObservedObject
    private var viewModel: ViewModel

    @State
    private var selectedTab: ItemsTab

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        self.selectedTab = .onList
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ShoppingItemsView.OnListView(viewModel)
                .background(Gradient(colors: [.clear, .mint.opacity(0.15)]))
                .tag(ItemsTab.onList)

            ShoppingItemsView.InBasketView(viewModel)
                .background(Gradient(colors: [.clear, .yellow.opacity(0.15)]))
                .tag(ItemsTab.inBasket)
        }
        .navigationTitle(Text(headerTitle))
        .task {
            await viewModel.fetchShoppingItems()
        }
    }

    private var headerTitle: String {
        switch selectedTab {
        case .onList:
            return "🗒️ \(viewModel.listName)"
        case .inBasket:
            return "🛒 \(viewModel.listName)"
        }
    }
}

private extension ShoppingItemsView {
    enum ItemsTab {
        case onList
        case inBasket
    }
}
