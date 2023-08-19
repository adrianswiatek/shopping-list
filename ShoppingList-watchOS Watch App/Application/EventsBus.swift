import Combine

final class EventsBus {
    var eventsPublisher: AnyPublisher<Event, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject: PassthroughSubject<Event, Never> = .init()

    func publish(_ event: Event) {
        eventsSubject.send(event)
    }
}

enum Event {
    case modelUpdated
}
