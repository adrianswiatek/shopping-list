public protocol CommandRefiner {
    func canRefine(_ command: Command) -> Bool
    func refine(_ command: Command) -> Command
}
