public protocol LocalPreferences {
    func defaultCategoryName() -> String
    func setDefaultCategoryName(_ name: String)
}
