protocol Command {
    var source: CommandSource { get }
    
    func canExecute() -> Bool
    func execute()
    func undo()
}
