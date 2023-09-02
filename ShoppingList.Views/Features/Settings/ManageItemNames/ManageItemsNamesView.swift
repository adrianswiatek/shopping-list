import ShoppingList_ViewModels

import SwiftUI

struct ManageItemsNamesView: View {
    @ObservedObject
    private var viewModel: ManageItemsNamesViewModel

    @FocusState
    private var focusedTextField: Bool

    init(viewModel: ManageItemsNamesViewModel) {
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

            List(viewModel.items, id: \.self) { item in
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
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        viewModel.showEditItem(item)
                    } label: {
                        Image("Edit")
                            .renderingMode(.template)
                            .tint(.white)
                    }
                    .tint(.blue)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.removeItemName(item)
                    } label: {
                        Image("Trash")
                            .renderingMode(.template)
                            .foregroundColor(Color.white)
                    }
                }
            }
            .listStyle(.inset)
            .shadow(color: .gray.opacity(0.5), radius: 2)
        }
        .navigationTitle("Manage Items Names")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Edit Item Name", isPresented: $viewModel.isEditItemNamePresented) {
            TextField("Enter item name", text: $viewModel.editItemNameViewModel.newName)
                .textInputAutocapitalization(.never)
            Button("OK", action: viewModel.confirmItemNameChange)
            Button("Cancel", role: .cancel) { }
        }
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
}
