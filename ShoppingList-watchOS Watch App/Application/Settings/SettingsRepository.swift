protocol SettingsRepository {
    func clearAll()
    func get<T>(_ key: Settings.Key) -> T?
    func get<T>(_ key: Settings.Key, default: T) -> T
    func set<T>(_ option: Settings.Option<T>)
}
