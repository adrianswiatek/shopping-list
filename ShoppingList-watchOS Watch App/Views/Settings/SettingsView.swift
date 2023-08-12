import SwiftUI

struct SettingsView: View {
    @ObservedObject
    private var viewModel: ViewModel

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Settings")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)

            Form {
                Toggle(isOn: $viewModel.isOn) {
                    Text("Synchronize basket")
                }
                .toggleStyle(.switch)
            }
        }
    }
}
