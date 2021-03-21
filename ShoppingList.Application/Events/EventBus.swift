import Combine

public final class EventBus {
    public let events: AnyPublisher<Event, Never>
    private let eventsSubject: PassthroughSubject<Event, Never>

    public init() {
        eventsSubject = .init()
        events = eventsSubject.share().eraseToAnyPublisher()
    }

    public func send(_ event: Event) {
        eventsSubject.send(event)
    }
}
