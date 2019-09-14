final class CommandInvoker {
    static let shared = CommandInvoker()
    
    private var commands: [CommandSource: Command] = [:]
    
    func execute(_ command: Command) {
        guard command.canExecute() else { return }
        commands[command.source] = command
        command.execute()
    }
    
    func undo(_ source: CommandSource) {
        let command = remove(source)
        command?.undo()
    }
    
    func canUndo(_ source: CommandSource) -> Bool {
        return commands[source] != nil
    }
    
    @discardableResult
    func remove(_ source: CommandSource) -> Command? {
        return commands.removeValue(forKey: source)
    }
}
