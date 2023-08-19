import SwiftUI

extension ShoppingItemsView {
    struct OnListView: View {
        @ObservedObject
        private var viewModel: ShoppingItemsView.ViewModel

        init(_ viewModel: ShoppingItemsView.ViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            if viewModel.hasItemsOnList {
                switch viewModel.listViewType {
                case .withCategories:
                    List(viewModel.itemsOnListWithCategories) { itemsWithCategory in
                        Section(header: Text(itemsWithCategory.category).opacity(0.5)) {
                            ForEach(itemsWithCategory.items, content: item)
                        }
                    }
                case .withoutCategories:
                    List(viewModel.itemsOnListWithoutCategories, rowContent: item)
                }
            } else {
                EmptyListText("You have empty list")
            }
        }

        private func item(_ item: ShoppingItemViewModel) -> some View {
            Button {
                Task {
                    await viewModel.moveToBasket(item.id)
                }
            } label: {
                Text(item.name)
            }
            .listRowBackground(RoundedRectangle(cornerRadius: 16)
                .fill(Gradient(colors: [.mint.opacity(0.15), .mint.opacity(0.2)]))
            )
        }
    }
}
