public final class InMemoryCommandInvoker: CommandInvoker {
    private var commands: [CommandSource: CommandNew]
    private let commandHandlers: [CommandHandler]

    public init(commandHandlers: [CommandHandler]) {
        self.commandHandlers = commandHandlers
        self.commands = [:]
    }

    public func execute(_ command: CommandNew) {
        let commandHandler = commandHandlers.first { $0.canExecute(command) }
        guard commandHandler != nil else { return }

        commands[command.source] = command
        commandHandler!.execute(command)
    }

    public func undo(_ source: CommandSource) {
        guard let command = remove(source)?.reversed() else {
            return
        }

        commandHandlers.first { $0.canExecute(command) }?.execute(command)
    }

    public func canUndo(_ source: CommandSource) -> Bool {
        let commandHandler = commands[source]?.reversed().flatMap { command in
            commandHandlers.first { $0.canExecute(command) }
        }
        return commandHandler != nil
    }

    @discardableResult
    public func remove(_ source: CommandSource) -> CommandNew? {
        commands.removeValue(forKey: source)
    }
}
