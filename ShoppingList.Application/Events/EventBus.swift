import Combine

public final class EventBus {
    public var events: AnyPublisher<Event, Never> {
        eventsSubject.share().eraseToAnyPublisher()
    }

    private let eventsSubject: PassthroughSubject<Event, Never>

    public init() {
        eventsSubject = .init()
    }

    public func send(_ event: Event) {
        eventsSubject.send(event)
    }
}
