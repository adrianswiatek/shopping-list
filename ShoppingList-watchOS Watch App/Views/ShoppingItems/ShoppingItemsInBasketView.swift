import SwiftUI

extension ShoppingItemsView {
    struct InBasketView: View {
        @ObservedObject
        private var viewModel: ShoppingItemsView.ViewModel

        init(_ viewModel: ShoppingItemsView.ViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            if viewModel.hasItemsInBasket {
                List(viewModel.itemsInBasket) { item in
                    Button {
                        Task {
                            await viewModel.moveToList(item.id)
                        }
                    } label: {
                        Text(item.name)
                    }
                    .listRowBackground(RoundedRectangle(cornerRadius: 16)
                        .fill(Gradient(colors: [.yellow.opacity(0.15), .yellow.opacity(0.2)]))
                    )
                }
            } else {
                EmptyListText("You have empty basket")
            }
        }
    }
}
