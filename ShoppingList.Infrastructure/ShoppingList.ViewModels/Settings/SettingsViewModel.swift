public final class SettingsViewModel: ViewModel {
    public let numberOfSettings: Int

    private let settings: [Settings]

    public init() {
        settings = [.manageCategories]
        numberOfSettings = settings.count
    }

    public func settings(for index: Int) -> Settings {
        settings[index]
    }
}

public extension SettingsViewModel {
    enum Settings: String {
        case manageCategories = "Manage Categories"
    }
}
