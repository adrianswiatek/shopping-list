import ShoppingList_ViewModels

import SwiftUI

struct CreateItemFromModelSummaryView: View {
    private let viewModel: CreateItemFromModelSummaryViewModel

    init(viewModel: CreateItemFromModelSummaryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometryReaderProxy in
            VStack(spacing: 48) {
                Text("Summary")
                    .foregroundColor(.black.opacity(0.75))
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

                Button(action: viewModel.confirmSelection) {
                    Label("Add to list", systemImage: "checkmark.circle.fill")
                        .frame(width: geometryReaderProxy.size.width / 1.5, height: 44)
                        .background(Color.gray.opacity(0.2).cornerRadius(8))
                }
                .padding(.bottom, 24)
            }
            .frame(height: geometryReaderProxy.size.height)
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
                .fill(.black.opacity(0.6))
                .frame(width: 5, height: 64)
                .padding(.leading, 32)

            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .foregroundColor(.black.opacity(0.75))

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
