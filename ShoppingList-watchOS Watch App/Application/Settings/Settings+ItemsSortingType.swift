extension Settings {
    struct ItemsSortingOptions {
        let type: ItemsSortingType
        let order: ItemsSortingOrder

        static var `default`: ItemsSortingOptions {
            .init(type: .alphabeticalOrder, order: .ascending)
        }
    }

    enum ItemsSortingType: String {
        case alphabeticalOrder
        case updatingOrder
    }

    enum ItemsSortingOrder: String {
        case ascending
        case descending
    }
}
