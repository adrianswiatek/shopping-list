public extension Optional {
    func `guard`(_ predicate: (Wrapped) -> Bool) -> Self {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            return predicate(wrapped) ? self : nil
        }
    }

    func `do`(_ action: (Wrapped) -> Void) {
        switch self {
        case .none:
            return
        case .some(let wrapped):
            action(wrapped)
        }
    }
}
