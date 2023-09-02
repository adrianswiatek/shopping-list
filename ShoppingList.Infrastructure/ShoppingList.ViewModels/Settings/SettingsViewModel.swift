public final class SettingsViewModel: ViewModel {
    public let numberOfSettings: Int

    private let settings: [Settings]

    public init() {
        settings = [.generalSettings, .manageCategories, .manageItemsNames]
        numberOfSettings = settings.count
    }

    public func settings(for index: Int) -> Settings {
        settings[index]
    }
}

public extension SettingsViewModel {
    enum Settings: String, CaseIterable {
        case generalSettings = "General Settings"
        case manageCategories = "Manage Categories"
        case manageItemsNames = "Manage Items Names"

        public static func fromIndex(_ index: Int) -> Settings? {
            allCasesIndexed[index]
        }

        public static var allCasesIndexed: [Int: Settings] {
            let allIndices: [Int] = Array(0 ... allCases.count - 1)
            return Dictionary(uniqueKeysWithValues: zip(allIndices, allCases))
        }
    }
}
