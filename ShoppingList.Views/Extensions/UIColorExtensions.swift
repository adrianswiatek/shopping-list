import UIKit

extension UIColor {
    internal static var textPrimary: UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? .white : .black }.withAlphaComponent(0.75)
    }

    internal static var textSecondary: UIColor {
        systemGray
    }

    internal static var background: UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? black : white }
    }

    internal static var remove: UIColor {
        systemRed
    }

    internal static var edit: UIColor {
        systemBlue
    }

    internal static var share: UIColor {
        systemTeal
    }

    internal static var line: UIColor {
        systemGray4
    }

    internal static var header: UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? .init(white: 0.1, alpha: 1) : .init(white: 0.9, alpha: 1) }
    }
}
