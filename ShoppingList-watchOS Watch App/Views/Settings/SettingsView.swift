import SwiftUI

struct SettingsView: View {
    @ObservedObject
    private var viewModel: ViewModel

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Items to buy") {
                    Toggle(isOn: $viewModel.showCategoriesOfItemsToBuy) {
                        Text("Show categories")
                    }
                    .toggleStyle(.switch)

                    Picker("Sorting", selection: $viewModel.listSortingType) {
                        listSortingOption(.inAscendingOrder)
                        listSortingOption(.inDescendingOrder)
                    }
                    .pickerStyle(.navigationLink)
                }

                Section("Items in basket") {
                    Toggle(isOn: $viewModel.synchronizeBasket) {
                        Text("Synchronize")
                    }
                    .toggleStyle(.switch)

                    Picker("Sorting", selection: $viewModel.basketSortingType) {
                        basketSortingOption(.inAlphabeticalOrder)
                        basketSortingOption(.inOrderOfAddition)
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func listSortingOption(_ sortingType: ListSortingType) -> some View {
        Text(sortingType.formatted).tag(sortingType)
    }

    private func basketSortingOption(_ sortingType: BasketSortingType) -> some View {
        Text(sortingType.formatted).tag(sortingType)
    }
}
