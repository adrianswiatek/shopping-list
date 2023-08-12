import SwiftUI

extension SettingsView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published
        var isOn: Bool {
            didSet {
                settingsRepository.set(Settings.Option(key: .synchronizeBasket, value: isOn))
            }
        }

        private let settingsRepository: SettingsRepository

        init(settingsRepository: SettingsRepository) {
            self.settingsRepository = settingsRepository
            self.isOn = settingsRepository.get(.synchronizeBasket) ?? true
        }
    }
}
