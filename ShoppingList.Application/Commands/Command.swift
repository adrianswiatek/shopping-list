public protocol Command {
    var source: CommandSource { get }
    
    func canExecute() -> Bool
    func execute()
    func undo()
}

public protocol CommandNew {
    var source: CommandSource { get }
    func reversed() -> CommandNew?
}

extension CommandNew {
    public func reversed() -> CommandNew? {
        nil
    }
}
