public final class CommandBus {
    private var commands: [CommandSource: Command]
    private let commandHandlers: [CommandHandler]

    public init(commandHandlers: [CommandHandler]) {
        self.commandHandlers = commandHandlers
        self.commands = [:]
    }

    public func execute(_ command: Command) {
        let commandHandler = commandHandlers.first { $0.canExecute(command) }
        guard commandHandler != nil else { return }

        if command.reversed() != nil {
            commands[command.source] = command
        }

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
    public func remove(_ source: CommandSource) -> Command? {
        commands.removeValue(forKey: source)
    }
}
