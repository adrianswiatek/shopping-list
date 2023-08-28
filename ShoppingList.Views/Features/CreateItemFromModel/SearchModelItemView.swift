import ShoppingList_ViewModels

import SwiftUI

struct SearchModelItemView: View {
    @ObservedObject
    private var viewModel: SearchModelItemViewModel

    @FocusState
    private var focusedTextField: Bool
    
    init(viewModel: SearchModelItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter item name...", text: $viewModel.searchTerm)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.plain)
                    .foregroundColor(.gray)
                    .focused($focusedTextField)
                
                if viewModel.canShowClearSearchTermButton {
                    Button {
                        viewModel.clearSearchTerm()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.gray)
                            .opacity(0.5)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 8)
            .padding(.horizontal, 20)
            
            List(viewModel.items, id: \.self, selection: $viewModel.selectedItem) { item in
                Group {
                    if let foundName = item.foundName {
                        HStack(spacing: 0) {
                            textView(foundName.prefix)
                            textView(foundName.foundPart, bold: true)
                            textView(foundName.suffix)
                        }
                    } else {
                        textView(item.name)
                    }
                }
                .listRowBackground(backgroundForItem(item))
            }
            .listStyle(.inset)
            .shadow(color: .gray.opacity(0.5), radius: 2)
        }
        .navigationTitle("Search Item")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { focusedTextField = true }
        .onDisappear { viewModel.searchTerm = "" }
    }
    
    private func textView(_ text: String, bold: Bool = false) -> some View {
        Text(text)
            .font(.callout)
            .fontWeight(bold ? .bold : .regular)
            .lineLimit(1)
            .opacity(0.75)
    }
    
    private func backgroundForItem(_ item: ItemToSearchViewModel) -> Color {
        item == viewModel.selectedItem ? .secondary.opacity(0.25) : .clear
    }
}
