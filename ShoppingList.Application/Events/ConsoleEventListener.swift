import Combine

public final class ConsoleEventListener {
    private let eventBus: EventBus
    private var cancellable: AnyCancellable?

    public init(eventBus: EventBus) {
        self.eventBus = eventBus
    }

    public func start() {
        cancellable = eventBus.events.sink { print($0.description) }
    }
}
