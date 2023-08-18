final class SettingsService {
    private let repository: SettingsRepository

    init(repository: SettingsRepository) {
        self.repository = repository
    }

    func clearSettings() {
        repository.clearAll()
    }

    func setValue<T>(_ value: T, forKey key: Settings.Key) {
        repository.set(Settings.Option(key: key, value: value))
    }

    func basketSortingOptions() -> Settings.ItemsSortingOptions {
        let sortingType: String? = repository.get(.basketSortingType)
        let sortingOptions = sortingType
            .flatMap(Settings.ItemsSortingType.init)
            .map { Settings.ItemsSortingOptions(type: $0, order: .ascending) }
        return sortingOptions ?? .default
    }

    func itemsStateSynchronizationMode() -> Settings.ItemsStateSynchronizationMode {
        let synchronizationMode: String? = repository.get(.itemsStateSynchronizationMode)
        return synchronizationMode.flatMap(Settings.ItemsStateSynchronizationMode.init) ?? .iPhoneFirst
    }

    func listSortingOptions() -> Settings.ItemsSortingOptions {
        let sortingOrder: String? = repository.get(.listSortingOrder)
        let sortingOptions = sortingOrder
            .flatMap(Settings.ItemsSortingOrder.init)
            .map { Settings.ItemsSortingOptions(type: .alphabeticalOrder, order: $0) }
        return sortingOptions ?? .default
    }

    func showCategoriesOfItemsToBuy() -> Bool {
        repository.get(.showCategoriesOfItemsToBuy, default: true)
    }

    func synchronizeBasket() -> Bool {
        repository.get(.synchronizeBasket, default: true)
    }
}
