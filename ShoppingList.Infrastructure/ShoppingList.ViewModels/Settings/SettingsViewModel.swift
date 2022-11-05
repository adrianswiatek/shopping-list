public final class SettingsViewModel: ViewModel {
    public let numberOfSettings: Int

    private let settings: [Settings]

    public init() {
        settings = [.manageCategories, .manageItems]
        numberOfSettings = settings.count
    }

    public func settings(for index: Int) -> Settings {
        settings[index]
    }
}

public extension SettingsViewModel {
    enum Settings: String, CaseIterable {
        case manageCategories = "Manage Categories"
        case manageItems = "Manage Items"

        public static func fromIndex(_ index: Int) -> Settings? {
            allCasesIndexed[index]
        }

        public static var allCasesIndexed: [Int: Settings] {
            let allIndices: [Int] = Array(0 ... allCases.count - 1)
            return Dictionary(uniqueKeysWithValues: zip(allIndices, allCases))
        }
    }
}
