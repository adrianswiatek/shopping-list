public final class CommandInvoker {
    public static let shared = CommandInvoker()
    
    private var commands: [CommandSource: Command] = [:]
    
    public func execute(_ command: Command) {
        guard command.canExecute() else { return }
        commands[command.source] = command
        command.execute()
    }
    
    public func undo(_ source: CommandSource) {
        remove(source)?.undo()
    }
    
    public func canUndo(_ source: CommandSource) -> Bool {
        commands[source] != nil
    }
    
    @discardableResult
    func remove(_ source: CommandSource) -> Command? {
        commands.removeValue(forKey: source)
    }
}
