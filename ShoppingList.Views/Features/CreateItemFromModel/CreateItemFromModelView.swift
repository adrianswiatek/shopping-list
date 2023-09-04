import ShoppingList_ViewModels

import SwiftUI

struct CreateItemFromModelView: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @ObservedObject
    private var viewModel: CreateItemFromModelViewModel

    init(viewModel: CreateItemFromModelViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewMode {
                case .searchItem:
                    SearchModelItemView(viewModel: viewModel.searchModelItemViewModel)
                case .selectCategory:
                    SelectItemsCategoryView(viewModel: viewModel.selectItemsCategoryViewModel)
                case .summary:
                    CreateItemFromModelSummaryView(viewModel: viewModel.summaryViewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}
