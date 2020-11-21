public func configure<T>(_ object: T, configure: (inout T) -> Void) -> T {
    var object = object
    configure(&object)
    return object
}
