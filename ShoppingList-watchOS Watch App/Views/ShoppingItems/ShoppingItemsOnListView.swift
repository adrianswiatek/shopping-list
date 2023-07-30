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
                List(viewModel.itemsOnList) { itemsWithCategory in
                    Section(header: Text(itemsWithCategory.category).opacity(0.5)) {
                        ForEach(itemsWithCategory.items) { item in
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
            } else {
                EmptyListText("You have empty list")
            }
        }
    }
}
