public final class CommandRefiners: CommandRefiner {
    private let refiners: [CommandRefiner]

    public init(_ refiners: CommandRefiner...) {
        self.refiners = refiners
    }

    public func canRefine(_ command: Command) -> Bool {
        refiners.first { $0.canRefine(command) } != nil
    }

    public func refine(_ command: Command) -> Command {
        let refiner = refiners.first { $0.canRefine(command) }
        precondition(refiner != nil, "Cannot refine given command.")
        return refiner!.refine(command)
    }
}
