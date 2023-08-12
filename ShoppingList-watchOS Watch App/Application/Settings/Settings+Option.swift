enum Settings {
    struct Option<T> {
        let key: Key
        let value: T
    }

    enum Key: String {
        case synchronizeBasket
    }
}
