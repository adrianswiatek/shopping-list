import ShoppingList_ViewModels

import SwiftUI

struct CreateItemFromModelSummaryView: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @ObservedObject
    private var viewModel: CreateItemFromModelSummaryViewModel

    init(viewModel: CreateItemFromModelSummaryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 48) {
                Text("Summary")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top, 24)

                Spacer()

                section(title: "Selected item", value: viewModel.selectedItem?.name ?? "") {
                    viewModel.switchItem()
                }

                section(title: "Selected category", value: viewModel.selectedCategory?.name ?? "") {
                    viewModel.switchCategory()
                }

                Spacer()

                Divider()

                VStack(spacing: 24) {
                    Button {
                        viewModel.confirmSelection()
                        dismiss()
                    } label: {
                        Label("Add to list", systemImage: "checkmark.circle.fill")
                            .frame(width: proxy.size.width / 1.25, height: 44)
                            .background(Color.secondary.opacity(0.15).cornerRadius(8))
                    }

                    Toggle("Skip this screen next time", isOn: $viewModel.skipSummaryScreen)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(width: proxy.size.width / 1.25)
                        .padding(.bottom, 24)
                }
            }
            .frame(height: proxy.size.height)
        }
        .padding()
    }

    private func section(
        title: String,
        value: String,
        action: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 24) {
            Rectangle()
                .fill(.secondary.opacity(0.4))
                .frame(width: 5, height: 64)
                .padding(.leading, 32)

            VStack(alignment: .leading, spacing: 12) {
                Text(title)

                Button(action: action) {
                    Text(value)
                        .font(.system(.title3))
                        .fontWeight(.bold)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
