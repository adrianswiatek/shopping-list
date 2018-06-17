extension Collection where Element == Category {
    func containsDefaultCategory() -> Bool {
        return self.first { $0.id == Category.getDefault().id } != nil
    }
}
