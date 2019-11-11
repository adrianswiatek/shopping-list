import UIKit

extension UIColor {
    static var textPrimary: UIColor {
        if #available(iOS 13, *) {
            return systemGray
        }
        return darkGray
    }

    static var textSecondary: UIColor {
        if #available(iOS 13, *) {
            return systemGray2
        }
        return gray
    }

    static var background: UIColor {
        if #available(iOS 13, *) {
            return UIColor { $0.userInterfaceStyle == .dark ? black : white }
        }
        return white
    }

    static var delete: UIColor {
        return systemRed
    }

    static var edit: UIColor {
        return systemBlue
    }

    static var share: UIColor {
        return systemTeal
    }

    static var line: UIColor {
        if #available(iOS 13, *) {
            return systemGray4
        }
        return lightGray
    }

    static var header: UIColor {
        if #available(iOS 13, *) {
            return UIColor {
                $0.userInterfaceStyle == .dark ? .init(white: 0.1, alpha: 1) : .init(white: 0.9, alpha: 1)
            }
        }
        return darkGray
    }
}
