public enum Either<Left, Right>: Hashable where Left: Hashable, Right: Hashable {
    case left(Left)
    case right(Right)

    public var maybeLeft: Left? {
        if case .left(let t) = self {
            return t
        }
        return nil
    }

    public var maybeRight: Right? {
        if case .right(let k) = self {
            return k
        }
        return nil
    }

    public func either<T>(ifLeft: (Left) -> T, ifRight: (Right) -> T) -> T {
        switch self {
        case .left(let left):
            return ifLeft(left)
        case .right(let right):
            return ifRight(right)
        }
    }

    public func map<NewRight>(
        _ transform: (Right) -> NewRight
    ) -> Either<Left, NewRight> {
        switch self {
        case .left(let left):
            return .left(left)
        case .right(let right):
            return .right(transform(right))
        }
    }

    public func flatMap<NewRight>(
        _ transform: (Right) -> Either<Left, NewRight>
    ) -> Either<Left, NewRight> {
        switch self {
        case .left(let left):
            return .left(left)
        case .right(let right):
            return transform(right)
        }
    }
}
