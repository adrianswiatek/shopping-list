import ShoppingList_ViewModels

import SwiftUI

struct SearchModelItemView: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @ObservedObject
    private var viewModel: SearchModelItemViewModel

    init(viewModel: SearchModelItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter item name...", text: $viewModel.searchTerm)
                        .textFieldStyle(.plain)
                        .foregroundColor(.gray)

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
                }
                .listStyle(.inset)
                .shadow(color: .gray.opacity(0.5), radius: 2)
            }
            .navigationTitle("Search Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {

                    } label: {
                        Text("Done")
                    }
                    .disabled(viewModel.selectedItem == nil)
                }

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

    private func textView(_ text: String, bold: Bool = false) -> some View {
        Text(text)
            .font(.callout)
            .fontWeight(bold ? .bold : .regular)
            .lineLimit(1)
            .opacity(0.75)
    }
}
