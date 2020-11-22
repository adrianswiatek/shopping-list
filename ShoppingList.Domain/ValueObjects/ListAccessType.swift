public enum ListAccessType: Int {
    case `private`
    case shared
}

extension ListAccessType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .private: return "private"
        case .shared: return "shared"
        }
    }
}
