public protocol Alternative<T> {
    associatedtype T

    var empty: Self { get }
    func alternative(lhs: Self, rhs: Self) -> Self
}
