import Combine

public final class EventBus {
    public var events: AnyPublisher<Event, Never> {
        eventsSubject
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }

    private let eventsSubject: PassthroughSubject<Event, Never>

    public init() {
        self.eventsSubject = .init()
    }

    public func send(_ event: Event) {
        eventsSubject.send(event)
    }
}
