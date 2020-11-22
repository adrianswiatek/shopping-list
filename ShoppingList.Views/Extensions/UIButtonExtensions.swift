import UIKit

extension UIButton {
    public func setListItemButton(with image: UIImage) {
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = .textPrimary
    }
}
