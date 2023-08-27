public protocol LocalPreferences {
    var defaultCategoryName: String { get nonmutating set }
    var shouldSkipSearchSummaryView: Bool { get nonmutating set }
}
