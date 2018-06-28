enum ListAccessType: Int, CustomStringConvertible {
    case `private`
    case shared
    
    var description: String {
        switch self {
        case .private: return "private"
        case .shared: return "shared"
        }
    }
}
