public protocol TestContainer {
    func resolve<T>(_ type: T.Type) -> T
}
