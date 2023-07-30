import SwiftUI

struct ShoppingListsView: View {
    @ObservedObject
    private var viewModel: ViewModel

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            if viewModel.hasLists {
                List {
                    ForEach(viewModel.lists) { list in
                        NavigationLink(value: list) {
                            Text(list.name)
                        }
                        .listRowBackground(RoundedRectangle(cornerRadius: 16)
                            .fill(Gradient(colors: [.blue.opacity(0.15), .blue.opacity(0.2)]))
                        )
                    }
                    .onDelete { indexSet in
                        Task {
                            await viewModel.deleteList(indexSet)
                        }
                    }
                }
            } else {
                EmptyListText("You ain't got any lists")
            }
        }
        .background(Gradient(colors: [.clear, .blue.opacity(0.15)]))
        .navigationTitle(Text("Your lists"))
        .task { await viewModel.fetchShoppingLists() }
    }
}
