enum Settings {
    struct Option<T> {
        let key: Key
        let value: T
    }

    enum Key: String, CaseIterable {
        case basketSortingType
        case itemsStateSynchronizationMode
        case listSortingOrder
        case showCategoriesOfItemsToBuy
        case synchronizeBasket
    }
}
