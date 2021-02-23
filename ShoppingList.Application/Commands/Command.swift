public protocol Command {
    var source: CommandSource { get }
    func reversed() -> Command?
}

extension Command {
    public func reversed() -> Command? {
        nil
    }
}
