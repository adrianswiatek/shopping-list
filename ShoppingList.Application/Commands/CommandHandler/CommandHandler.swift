public protocol CommandHandler {
    func canExecute(_ command: Command) -> Bool
    func execute(_ command: Command) throws
}
