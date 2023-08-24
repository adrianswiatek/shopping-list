import ShoppingList_ViewModels

import SwiftUI

struct SelectItemsCategoryView: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @ObservedObject
    private var viewModel: SelectItemsCategoryViewModel

    init(viewModel: SelectItemsCategoryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            List(viewModel.categories, id: \.self, selection: $viewModel.selectedCategory) {
                Text($0.name)
                    .font(.callout)
                    .lineLimit(1)
                    .opacity(0.75)
                    .listRowBackground(backgroundForCategory($0))
            }
            .listStyle(.inset)
            .navigationTitle("Select category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.selectDefaultCategory()
                    } label: {
                        Text("Skip")
                    }
                    .disabled(viewModel.selectedCategory != nil)
                }
            }
        }
    }

    private func backgroundForCategory(_ category: ItemsCategoryViewModel) -> Color {
        category == viewModel.selectedCategory ? .gray.opacity(0.25) : .white
    }
}
