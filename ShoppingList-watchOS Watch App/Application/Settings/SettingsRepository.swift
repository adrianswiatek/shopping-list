protocol SettingsRepository {
    func set<T>(_ option: Settings.Option<T>)
    func get<T>(_ key: Settings.Key) -> T?
}
