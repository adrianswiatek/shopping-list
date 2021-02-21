public protocol CommandBus {
    func execute(_ command: Command)

    func canUndo(_ source: CommandSource) -> Bool
    func undo(_ source: CommandSource)

    @discardableResult
    func remove(_ source: CommandSource) -> Command?
}
