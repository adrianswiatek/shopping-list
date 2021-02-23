import ShoppingList_Application

public final class UserDefaultsAdapter: LocalPreferences {
    private let userDefaults: UserDefaults

    public init(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func defaultCategoryName() -> String {
        userDefaults.value(forKey: Key.defaultCategoryName) as? String ?? "Default"
    }

    public func setDefaultCategoryName(_ name: String) {
        userDefaults.setValue(name, forKey: Key.defaultCategoryName)
    }
}

private extension UserDefaultsAdapter {
    enum Key {
        static let defaultCategoryName = "defaultCategoryName"
    }
}
