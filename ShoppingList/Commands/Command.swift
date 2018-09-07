protocol Command {
    var source: CommandSource { get }
    
    func execute()
    func undo()
}
