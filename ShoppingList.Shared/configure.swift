public func configure<T>(_ object: T, configure: (inout T) -> Void) -> T {
    var object = object
    configure(&object)
    return object
}

public func configure<T>(_ makeObject: () -> T, configure: (inout T) -> Void) -> T {
    var object = makeObject()
    configure(&object)
    return object
}
