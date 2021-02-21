public final class CommmandHandlers: CommandHandler {
    private let handlers: [CommandHandler]

    public init(_ handlers: CommandHandler...) {
        self.handlers = handlers
    }

    public func canExecute(_ command: Command) -> Bool {
        handlers.first { $0.canExecute(command) } != nil
    }

    public func execute(_ command: Command) {
        let handler = handlers.first { $0.canExecute(command) }
        precondition(handler != nil, "Cannot execute given command.")
        handler!.execute(command)
    }
}
