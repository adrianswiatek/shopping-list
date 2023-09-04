public extension Array {
    func `guard`(_ predicate: (Self) -> Bool) -> Self {
        predicate(self) ? self : []
    }

    func `do`(_ action: (Self) -> Void) {
        action(self)
    }

    func tail() -> [Element] {
        isEmpty ? [] : Array(self[1...])
    }
}
