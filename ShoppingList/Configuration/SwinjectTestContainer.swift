import Swinject

public final class SwinjectTestContainer: TestContainer {
    private let container: Swinject.Container

    public init(_ container: Swinject.Container) {
        self.container = container
    }

    public func resolve<T>(_ type: T.Type) -> T {
        container.resolve(type)!
    }
}
