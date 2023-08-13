import Foundation

final class UserDefaultsSettingsRepository: SettingsRepository {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func clearAll() {
        for key in Settings.Key.allCases {
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }

    func get<T>(_ key: Settings.Key) -> T? {
        userDefaults.value(forKey: key.rawValue) as? T
    }

    func get<T>(_ key: Settings.Key, default: T) -> T {
        get(key) ?? `default`
    }

    func set<T>(_ option: Settings.Option<T>) {
        userDefaults.set(option.value, forKey: option.key.rawValue)
    }
}
