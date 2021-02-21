public final class CommandBusAsyncDecorator: CommandBus {
    private let commandBus: CommandBus
    private let queue: DispatchQueue

    public init(_ commandBus: CommandBus) {
        self.commandBus = commandBus
        self.queue = DispatchQueue.global(qos: .userInitiated)
    }

    public func execute(_ command: Command) {
        queue.async {
            self.commandBus.execute(command)
        }
    }

    public func canUndo(_ source: CommandSource) -> Bool {
        commandBus.canUndo(source)
    }

    public func undo(_ source: CommandSource) {
        queue.async {
            self.commandBus.undo(source)
        }
    }

    public func remove(_ source: CommandSource) -> Command? {
        commandBus.remove(source)
    }
}
