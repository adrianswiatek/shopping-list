public protocol CommandInvoker {
    func execute(_ command: CommandNew)

    func undo(_ source: CommandSource)
    func canUndo(_ source: CommandSource) -> Bool

    @discardableResult
    func remove(_ source: CommandSource) -> CommandNew?
}
