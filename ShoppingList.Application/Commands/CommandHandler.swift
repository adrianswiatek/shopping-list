public protocol CommandHandler {
    func canExecute(_ command: CommandNew) -> Bool
    func execute(_ command: CommandNew)
}
