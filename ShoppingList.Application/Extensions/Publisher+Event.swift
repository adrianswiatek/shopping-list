import Combine

public extension Publisher where Output == Event {
    func filterType(_ types: Event.Type...) -> Publishers.Filter<Self> {
        filterType(types)
    }

    func filterType(_ types: [Event.Type]) -> Publishers.Filter<Self> {
        filter { event in types.contains { $0 == type(of: event) } }
    }
}
