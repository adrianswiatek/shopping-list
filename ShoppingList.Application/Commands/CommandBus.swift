public final class CommandBus {
    private let commandHandler: CommandHandler
    private let commandRefiner: CommandRefiner
    private var commands: [CommandSource: Command]

    public init(commandHandler: CommandHandler, commandRefiner: CommandRefiner) {
        self.commandHandler = commandHandler
        self.commandRefiner = commandRefiner
        self.commands = [:]
    }

    public func execute(_ command: Command) {
        let command = refined(command) ?? command

        guard commandHandler.canExecute(command) else {
            return
        }

        do {
            try commandHandler.execute(command)
            storeIfCanBeReversed(command)
        } catch {
            print(error)
        }
    }

    public func canUndo(_ source: CommandSource) -> Bool {
        commands[source]?.reversed().map { commandHandler.canExecute($0) } == true
    }

    public func undo(_ source: CommandSource) {
        guard
            let command = remove(source)?.reversed(),
            commandHandler.canExecute(command)
        else {
            return
        }

        do {
            try commandHandler.execute(command)
        } catch {
            print(error)
        }
    }

    @discardableResult
    public func remove(_ source: CommandSource) -> Command? {
        commands.removeValue(forKey: source)
    }

    private func refined(_ command: Command) -> Command? {
        commandRefiner.canRefine(command) ? commandRefiner.refine(command) : nil
    }

    private func storeIfCanBeReversed(_ command: Command) {
        if command.reversed() != nil {
            commands[command.source] = command
        }
    }
}
