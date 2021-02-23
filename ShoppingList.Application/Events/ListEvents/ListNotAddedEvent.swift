public struct ListNotAddedEvent: Event {
    public let reason: Reason

    public init(_ reason: Reason) {
        self.reason = reason
    }
}

extension ListNotAddedEvent {
    public enum Reason {
        case alreadyExists
    }
}
