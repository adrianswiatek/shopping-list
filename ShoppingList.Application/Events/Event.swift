public protocol Event: CustomStringConvertible {}

extension Event {
    public var description: String {
        "\(Self.self)"
    }
}
