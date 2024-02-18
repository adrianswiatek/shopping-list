import ShoppingList_ViewModels

import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject
    private var viewModel: GeneralSettingsViewModel

    init(viewModel: GeneralSettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Form {
            Section("Search Items") {
                Toggle("Skip summary screen", isOn: $viewModel.skipSearchSummaryView)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            }
        }
    }
}
