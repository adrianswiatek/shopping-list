import ShoppingList_Application

public final class UserDefaultsAdapter: LocalPreferences {
    public var defaultCategoryName: String {
        get { userDefaults.value(forKey: Key.defaultCategoryName) as? String ?? "Default" }
        set { userDefaults.setValue(newValue, forKey: Key.defaultCategoryName) }
    }

    public var shouldSkipSearchSummaryView: Bool {
        get { userDefaults.value(forKey: Key.skipSearchSummary) as? Bool ?? false }
        set { userDefaults.setValue(newValue, forKey: Key.skipSearchSummary) }
    }

    private let userDefaults: UserDefaults

    public init(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

private extension UserDefaultsAdapter {
    enum Key {
        static let defaultCategoryName = "defaultCategoryName"
        static let skipSearchSummary = "skipSearchSummary"
    }
}
